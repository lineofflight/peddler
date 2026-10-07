//! Protected, owned-work GVL release shared by requests and document transfers.
use super::{Shared, native_error};
use futures_util::FutureExt;
use magnus::{Error, Ruby, rb_sys::AsRawValue};
use std::{
    ffi::c_void,
    future::Future,
    panic::{AssertUnwindSafe, catch_unwind},
    pin::Pin,
};
use tokio::sync::Notify;

struct Invocation<F: Future> {
    shared: &'static Shared,
    // Pinned, so a pass that a wake-up ends is followed by another on the same work.
    future: Pin<Box<F>>,
    woken: *const Notify,
    // Empty until the work ends. A panic is `Err`.
    result: Option<Result<F::Output, ()>>,
}

/// Runs `future` to its end with the GVL released. Ruby wakes the thread for an
/// exception another thread raises in it, a kill, a signal and `Thread#wakeup`. Only
/// what Ruby then raises ends the work: the future is dropped and the exception goes
/// on. After a wake-up with nothing to raise (a trap that returns, a wakeup, an
/// exception the caller has masked) the same work goes on.
pub(super) fn wait<F>(
    ruby: &Ruby,
    failure_class: &str,
    shared: &'static Shared,
    future: F,
) -> Result<F::Output, Error>
where
    F: Future + Send + 'static,
    F::Output: Send + 'static,
{
    // Allocations stay outside protect so Ruby longjmp cannot skip their Drop.
    let woken = Box::new(Notify::new());
    let mut invocation = Box::new(Invocation {
        shared,
        future: Box::pin(future),
        woken: &*woken,
        result: None,
    });
    let nil = ruby.qnil().as_raw();
    let outcome = loop {
        let pass = magnus::rb_sys::protect(|| {
            // SAFETY: callback and unblock share only a separate Notify allocation;
            // all work owns Rust data and no Ruby calls occur under released GVL.
            // Ruby checks for interrupts when the callback returns and raises there.
            unsafe {
                rb_sys::rb_thread_call_without_gvl(
                    Some(run::<F>),
                    (&mut *invocation as *mut Invocation<F>).cast(),
                    Some(unblock),
                    (&*woken as *const Notify).cast_mut().cast(),
                );
            }
            nil
        });
        if let Err(error) = pass {
            break Err(error);
        }
        if let Some(result) = invocation.result.take() {
            break Ok(result);
        }
    };
    // Unfinished work is dropped where it ran, inside the runtime.
    let dropped = {
        let _context = shared.runtime.enter();
        catch_unwind(AssertUnwindSafe(|| drop(invocation)))
    };
    if let Err(payload) = dropped {
        std::mem::forget(payload);
    }
    outcome?.map_err(|()| native_error(ruby, failure_class, "native work failed"))
}
/// Polls `future` once, with the GVL held, and returns its output if it is ready, so a
/// row the stream has buffered doesn't wait for the GVL again. The work is Rust only:
/// chunks yield every chunk and JSONL and TSV yield a row or give way after every
/// chunk, so one poll decodes and frames at most one chunk and parses at most one
/// row. A panic maps to the error `wait` gives.
pub(super) fn now<F: Future>(
    ruby: &Ruby,
    failure_class: &str,
    shared: &'static Shared,
    future: F,
) -> Result<Option<F::Output>, Error> {
    let _context = shared.runtime.enter();
    catch_unwind(AssertUnwindSafe(|| future.now_or_never())).map_err(|payload| {
        std::mem::forget(payload);
        native_error(ruby, failure_class, "native work failed")
    })
}
unsafe extern "C" fn unblock(data: *mut c_void) {
    // SAFETY: wait owns this allocation until both callbacks have returned. A call
    // before the work waits leaves a permit, so it isn't lost.
    unsafe { &*data.cast::<Notify>() }.notify_one();
}
/// One pass: until the work ends or Ruby wakes the thread. The work is polled before
/// the wake-up, so every pass moves it on however often the thread is woken.
unsafe extern "C" fn run<F>(data: *mut c_void) -> *mut c_void
where
    F: Future + Send + 'static,
    F::Output: Send + 'static,
{
    // SAFETY: only this callback mutates Invocation during the synchronous wait.
    let invocation = unsafe { &mut *data.cast::<Invocation<F>>() };
    // SAFETY: the separate Notify outlives this callback.
    let woken = unsafe { &*invocation.woken };
    let pass = catch_unwind(AssertUnwindSafe(|| {
        invocation.shared.runtime.block_on(async {
            tokio::select! { biased;
                result = invocation.future.as_mut() => Some(result),
                () = woken.notified() => None,
            }
        })
    }));
    invocation.result = match pass {
        Ok(result) => result.map(Ok),
        Err(payload) => {
            std::mem::forget(payload);
            Some(Err(()))
        }
    };
    std::ptr::null_mut()
}
