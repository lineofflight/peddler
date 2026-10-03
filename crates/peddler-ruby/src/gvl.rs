//! Protected, owned-work GVL release shared by requests and document transfers.
use super::{Shared, native_error};
use futures_util::FutureExt;
use magnus::{Error, Ruby, rb_sys::AsRawValue};
use std::{
    ffi::c_void,
    future::Future,
    panic::{AssertUnwindSafe, catch_unwind},
};
use tokio::sync::Notify;

struct Invocation<F, T> {
    shared: &'static Shared,
    future: Option<F>,
    cancelled: *const Notify,
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
    let cancelled = Box::new(Notify::new());
    let mut invocation = Box::new(Invocation {
        shared,
        future: Some(future),
        cancelled: &*cancelled,
        result: None,
    });
    let nil = ruby.qnil().as_raw();
    magnus::rb_sys::protect(|| {
        // SAFETY: callback and unblock share only a separate Notify allocation;
        // all work owns Rust data and no Ruby calls occur under released GVL.
        unsafe {
            rb_sys::rb_thread_call_without_gvl(
                Some(run::<F, T>),
                (&mut *invocation as *mut Invocation<F, T>).cast(),
                Some(unblock),
                (&*cancelled as *const Notify).cast_mut().cast(),
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
/// Polls `future` once, with the GVL held, and returns its output if it is ready, so a
/// row the stream has buffered doesn't wait for the GVL again. The work is Rust only
/// and lasts until the stream yields or has nothing ready. Chunks yield every chunk,
/// and JSONL gives way after a chunk without a record, so each decodes and frames at
/// most one chunk and parses at most one record. TSV doesn't give way: csv-core skips
/// blank lines without a row, so a run of them is framed in one poll. A panic maps to
/// the error `wait` gives.
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
    // SAFETY: wait owns this allocation until both callbacks have returned. A call
    // before the work waits leaves a permit, so it isn't lost.
    unsafe { &*data.cast::<Notify>() }.notify_one();
}
unsafe extern "C" fn run<F: Future<Output = T> + Send + 'static, T: Send + 'static>(
    data: *mut c_void,
) -> *mut c_void {
    // SAFETY: only this callback mutates Invocation during the synchronous wait.
    let invocation = unsafe { &mut *data.cast::<Invocation<F, T>>() };
    let result = catch_unwind(AssertUnwindSafe(|| {
        let future = invocation.future.take().expect("work runs once");
        // SAFETY: the separate Notify outlives this callback.
        let cancelled = unsafe { &*invocation.cancelled };
        invocation.shared.runtime.block_on(async {
            tokio::select! { biased;
                () = cancelled.notified() => Err(()),
                result = future => Ok(result),
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
