//! Protected, owned-work GVL release shared by requests and document transfers.
use super::{RuntimeOwner, native_error};
use magnus::{Error, Ruby, rb_sys::AsRawValue};
use std::{
    ffi::c_void,
    future::Future,
    panic::{AssertUnwindSafe, catch_unwind},
    sync::{
        Arc,
        atomic::{AtomicBool, Ordering},
    },
    time::Duration,
};

struct Invocation<F, T> {
    runtime: Arc<RuntimeOwner>,
    future: Option<F>,
    cancelled: *const AtomicBool,
    result: Option<Result<T, ()>>,
}

pub(super) fn wait<F, T>(
    ruby: &Ruby,
    failure_class: &str,
    runtime: Arc<RuntimeOwner>,
    future: F,
) -> Result<T, Error>
where
    F: Future<Output = T> + Send + 'static,
    T: Send + 'static,
{
    // Allocations stay outside protect so Ruby longjmp cannot skip their Drop.
    let cancelled = Box::new(AtomicBool::new(false));
    let mut invocation = Box::new(Invocation {
        runtime,
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
        invocation.runtime.runtime.as_ref().expect("runtime alive").block_on(async {
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
