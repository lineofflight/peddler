//! Protected, owned-work GVL release shared by requests and document transfers.
use super::{Shared, native_error};
use futures_util::FutureExt;
use magnus::{Error, Ruby, rb_sys::AsRawValue};
use std::{
    ffi::c_void,
    future::Future,
    panic::{AssertUnwindSafe, catch_unwind},
    sync::atomic::{AtomicBool, Ordering},
    time::Duration,
};

struct Invocation<F, T> {
    shared: &'static Shared,
    future: Option<F>,
    cancelled: *const AtomicBool,
    result: Option<Result<T, ()>>,
}

pub(super) fn wait<F, T>(
    ruby: &Ruby,
    failure_class: &str,
    shared: &'static Shared,
    future: F,
) -> Result<T, Error>
where
    F: Future<Output = T> + Send + 'static,
    T: Send + 'static,
{
    // Allocations stay outside protect so Ruby longjmp cannot skip their Drop.
    let cancelled = Box::new(AtomicBool::new(false));
    let mut invocation = Box::new(Invocation {
        shared,
        future: Some(future),
        cancelled: &*cancelled,
        result: None,
    });
    let nil = ruby.qnil().as_raw();
    magnus::rb_sys::protect(|| {
        // SAFETY: callback and unblock share only a separate atomic allocation;
        // all work owns Rust data and no Ruby calls occur under released GVL.
        unsafe {
            rb_sys::rb_thread_call_without_gvl(
                Some(run::<F, T>),
                (&mut *invocation as *mut Invocation<F, T>).cast(),
                Some(unblock),
                (&*cancelled as *const AtomicBool).cast_mut().cast(),
            );
        }
        nil
    })?;
    invocation
        .result
        .take()
        .unwrap_or(Err(()))
        .map_err(|()| native_error(ruby, failure_class, "native work cancelled or failed"))
}
/// Polls `future` once, with the GVL held, and returns its output if it is ready. For
/// work that is often ready already, such as a row the stream has buffered, so it
/// doesn't wait for the GVL again. The work is Rust only, bounded by one chunk or
/// record, and a panic maps to the error `wait` gives.
pub(super) fn now<F: Future>(
    ruby: &Ruby,
    failure_class: &str,
    shared: &'static Shared,
    future: F,
) -> Result<Option<F::Output>, Error> {
    let _context = shared.runtime.enter();
    catch_unwind(AssertUnwindSafe(|| future.now_or_never())).map_err(|payload| {
        std::mem::forget(payload);
        native_error(ruby, failure_class, "native work cancelled or failed")
    })
}
unsafe extern "C" fn unblock(data: *mut c_void) {
    // SAFETY: wait owns this allocation until both callbacks have returned.
    unsafe { &*data.cast::<AtomicBool>() }.store(true, Ordering::Relaxed);
}
unsafe extern "C" fn run<F: Future<Output = T> + Send + 'static, T: Send + 'static>(
    data: *mut c_void,
) -> *mut c_void {
    // SAFETY: only this callback mutates Invocation during the synchronous wait.
    let invocation = unsafe { &mut *data.cast::<Invocation<F, T>>() };
    let result = catch_unwind(AssertUnwindSafe(|| {
        let future = invocation.future.take().expect("work runs once");
        // SAFETY: separate atomic outlives this callback.
        let cancelled = unsafe { &*invocation.cancelled };
        invocation.shared.runtime.block_on(async {
            tokio::select! {
                result = future => Ok(result),
                () = async { while !cancelled.load(Ordering::Relaxed) { tokio::time::sleep(Duration::from_millis(5)).await; } } => Err(()),
            }
        })
    }));
    invocation.result = Some(match result {
        Ok(value) => value,
        Err(payload) => {
            std::mem::forget(payload);
            Err(())
        }
    });
    std::ptr::null_mut()
}
