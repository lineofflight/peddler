//! Owned-data Ruby boundary. Only the blocking callback runs without the GVL.

use magnus::{Error, RModule, RString, Ruby, function, method, prelude::*, rb_sys::AsRawValue};
use peddler::{Client, Request, Response};
use std::{
    ffi::c_void,
    mem::ManuallyDrop,
    panic::{AssertUnwindSafe, catch_unwind},
    sync::{
        Arc,
        atomic::{AtomicBool, Ordering},
    },
    time::Duration,
};
use tokio::runtime::{Builder, Runtime};

type ResponseParts = (u16, Vec<(String, String)>, RString);

struct State {
    client: Client,
    runtime: Option<Runtime>,
}

impl Drop for State {
    fn drop(&mut self) {
        if let Some(runtime) = self.runtime.take() {
            // GC must never wait on Tokio's blocking pool (e.g. DNS).
            runtime.shutdown_background();
        }
    }
}

#[magnus::wrap(class = "Peddler::Native::Engine", free_immediately)]
struct Engine {
    pid: u32,
    state: ManuallyDrop<Arc<State>>,
}

impl Drop for Engine {
    fn drop(&mut self) {
        if self.pid == std::process::id() {
            // SAFETY: this field is dropped exactly once, only in its creator
            // process. The child must leak all inherited state, including the
            // reqwest client: its destructor may touch inherited locks.
            unsafe { ManuallyDrop::drop(&mut self.state) };
        }
    }
}

fn native_error(ruby: &Ruby, name: &str, message: &str) -> Error {
    let class = ruby
        .class_object()
        .const_get::<_, RModule>("Peddler")
        .and_then(|module| module.const_get::<_, RModule>("Native"))
        .and_then(|module| module.const_get(name));
    match class {
        Ok(class) => Error::new(class, message.to_owned()),
        Err(error) => error,
    }
}

fn transport_error(ruby: &Ruby, error: peddler::Error) -> Error {
    match error {
        peddler::Error::InvalidRequest => Error::new(ruby.exception_arg_error(), "invalid request"),
        peddler::Error::Timeout => native_error(ruby, "TimeoutError", "request timed out"),
        peddler::Error::Transport => native_error(ruby, "TransportError", "transport failed"),
    }
}

impl Engine {
    fn new(
        ruby: &Ruby,
        base_url: String,
        access_token: String,
        timeout: f64,
    ) -> Result<Self, Error> {
        let duration = Duration::try_from_secs_f64(timeout)
            .map_err(|_| Error::new(ruby.exception_arg_error(), "invalid timeout"))?;
        let client = Client::with_timeout(&base_url, &access_token, duration)
            .map_err(|error| transport_error(ruby, error))?;
        let runtime = Builder::new_multi_thread()
            .worker_threads(1)
            .enable_all()
            .build()
            .map_err(|_| native_error(ruby, "TransportError", "runtime initialization failed"))?;
        Ok(Self {
            pid: std::process::id(),
            state: ManuallyDrop::new(Arc::new(State {
                client,
                runtime: Some(runtime),
            })),
        })
    }

    fn request(
        ruby: &Ruby,
        engine: &Self,
        method: String,
        path: String,
        query: Vec<(String, String)>,
        body: Option<RString>,
    ) -> Result<ResponseParts, Error> {
        if engine.pid != std::process::id() {
            return Err(native_error(
                ruby,
                "ForkError",
                "create a new client after fork",
            ));
        }
        // SAFETY: the GVL is held; copy bytes before any Ruby call or GVL release.
        let body = body.map(|value| unsafe { value.as_slice().to_vec() });
        // Separate allocation: the unblock callback's shared AtomicBool reference
        // never aliases the run callback's mutable Invocation reference.
        let cancelled = Box::new(AtomicBool::new(false));
        let mut invocation = Box::new(Invocation {
            state: Arc::clone(&engine.state),
            request: Some(Request {
                method,
                path,
                query,
                body,
            }),
            cancelled: &*cancelled,
            result: None,
        });
        let nil = ruby.qnil().as_raw();
        // Keep both boxes OUTSIDE protect: Ruby longjmp must not skip their Drop.
        magnus::rb_sys::protect(|| {
            // SAFETY: both allocations outlive this synchronous call. run and
            // unblock touch only owned Rust data. protect catches Ruby interrupts
            // raised while reacquiring the GVL, and returns a valid Ruby VALUE.
            unsafe {
                rb_sys::rb_thread_call_without_gvl(
                    Some(run),
                    (&mut *invocation as *mut Invocation).cast(),
                    Some(unblock),
                    (&*cancelled as *const AtomicBool).cast_mut().cast(),
                );
            }
            nil
        })?;
        match invocation.result.take() {
            Some(Ok(response)) => Ok((
                response.status,
                response.headers,
                ruby.str_from_slice(&response.body),
            )),
            Some(Err(Failure::Transport(error))) => Err(transport_error(ruby, error)),
            Some(Err(Failure::Cancelled)) => {
                Err(native_error(ruby, "TransportError", "request cancelled"))
            }
            Some(Err(Failure::Panic)) | None => Err(native_error(
                ruby,
                "TransportError",
                "native request failed",
            )),
        }
    }
}

enum Failure {
    Transport(peddler::Error),
    Cancelled,
    Panic,
}

struct Invocation {
    state: Arc<State>,
    request: Option<Request>,
    cancelled: *const AtomicBool,
    result: Option<Result<Response, Failure>>,
}

unsafe extern "C" fn unblock(data: *mut c_void) {
    // SAFETY: request keeps the allocation alive until without_gvl returns.
    unsafe { &*data.cast::<AtomicBool>() }.store(true, Ordering::Relaxed);
}

unsafe extern "C" fn run(data: *mut c_void) -> *mut c_void {
    // SAFETY: only this callback accesses Invocation until without_gvl returns.
    let invocation = unsafe { &mut *data.cast::<Invocation>() };
    let outcome = catch_unwind(AssertUnwindSafe(|| {
        let request = invocation.request.take().expect("invocation runs once");
        // SAFETY: request owns this separate allocation for the entire call.
        let cancelled = unsafe { &*invocation.cancelled };
        invocation.state.runtime.as_ref().expect("runtime alive").block_on(async {
            tokio::select! {
                result = invocation.state.client.execute(request) => result.map_err(Failure::Transport),
                () = async {
                    while !cancelled.load(Ordering::Relaxed) {
                        tokio::time::sleep(Duration::from_millis(5)).await;
                    }
                } => Err(Failure::Cancelled),
            }
        })
    }));
    invocation.result = Some(match outcome {
        Ok(result) => result,
        Err(payload) => {
            // A custom panic payload's destructor could panic too. Never unwind
            // through the C callback; preserve only a sanitized failure marker.
            std::mem::forget(payload);
            Err(Failure::Panic)
        }
    });
    std::ptr::null_mut()
}

#[magnus::init(name = "peddler_native")]
fn init(ruby: &Ruby) -> Result<(), Error> {
    let peddler = ruby.define_module("Peddler")?;
    let native = peddler.define_module("Native")?;
    let error = native.define_class(
        "TransportError",
        ruby.exception_standard_error().as_r_class(),
    )?;
    native.define_class("TimeoutError", error)?;
    native.define_class("ForkError", ruby.exception_standard_error().as_r_class())?;
    let engine = native.define_class("Engine", ruby.class_object())?;
    engine.define_singleton_method("new", function!(Engine::new, 3))?;
    engine.define_method("request", method!(Engine::request, 4))?;
    Ok(())
}
