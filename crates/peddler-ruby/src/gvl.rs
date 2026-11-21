//! Protected, owned-work GVL release shared by requests and document transfers.
use super::{
    Shared, fork,
    hook::{self, Pass, Responder},
    native_error,
};
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
    // What the work asked of Ruby in the last pass. None in a call that answers nothing.
    pass: Option<Pass>,
}

/// Runs `future` to its end with the GVL released. Ruby wakes the thread for an
/// exception another thread raises in it, a kill, a signal and `Thread#wakeup`. Only
/// what Ruby then raises ends the work: the future is dropped and the exception goes
/// on. After a wake-up with nothing to raise (a trap that returns, a wakeup, an
/// exception the caller has masked) the same work goes on.
///
/// A trap handler may fork, and then it returns in the child too, inside this call.
/// The child raises `Peddler::ForkError`, which tells it to create `rebuild` again.
pub(super) fn wait<F>(
    ruby: &Ruby,
    failure_class: &str,
    rebuild: &'static str,
    shared: &'static Shared,
    future: F,
) -> Result<F::Output, Error>
where
    F: Future + Send + 'static,
    F::Output: Send + 'static,
{
    asking(ruby, failure_class, rebuild, shared, &mut None, future)
}

/// Like `wait`, for work that asks Ruby (see `hook`). A question ends the pass. The
/// responder answers it here, between passes, on the calling thread with the GVL held,
/// and the next pass goes on with the answer. So Ruby is never called from a poll of
/// the work or from a runtime thread, and what it calls may make a native call of its
/// own: no pass is running then.
///
/// What Ruby raises there ends the work as an interrupt does: the future is dropped and
/// the exception goes on, the same object. A callable may fork too, and then it returns
/// in the child as a trap handler does.
pub(super) fn asking<F>(
    ruby: &Ruby,
    failure_class: &str,
    rebuild: &'static str,
    shared: &'static Shared,
    responder: &mut Option<Responder>,
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
        pass: responder.as_ref().map(Responder::pass),
    });
    let nil = ruby.qnil().as_raw();
    let pid = std::process::id();
    let outcome = 'call: loop {
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
        // Ruby ran a trap handler that forked, and this is the child. The work belongs
        // to the parent's runtime, which has no threads here: it is neither polled nor
        // dropped. What Ruby raised, if anything, goes on.
        if std::process::id() != pid {
            std::mem::forget(invocation);
            return Err(pass.err().unwrap_or_else(|| fork::error(ruby, rebuild)));
        }
        if let Err(error) = pass {
            break Err(error);
        }
        if let Some(result) = invocation.result.take() {
            break Ok(result);
        }
        let Some(responder) = responder.as_mut() else {
            continue;
        };
        while let Some((question, reply)) = invocation.pass.as_mut().and_then(Pass::next) {
            let answer = catch_unwind(AssertUnwindSafe(|| responder.answer(ruby, question)));
            // Ruby forked while it was asked, and this is the child. As above.
            if std::process::id() != pid {
                std::mem::forget((invocation, reply));
                return Err(match answer {
                    Ok(Err(error)) => error,
                    Ok(Ok(_)) => fork::error(ruby, rebuild),
                    Err(payload) => {
                        std::mem::forget(payload);
                        fork::error(ruby, rebuild)
                    }
                });
            }
            match answer {
                // The work may have given the question up, and then nobody takes the answer.
                Ok(Ok(answer)) => drop(reply.send(answer)),
                Ok(Err(error)) => break 'call Err(error),
                Err(payload) => {
                    std::mem::forget(payload);
                    break 'call Ok(Err(()));
                }
            }
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
/// One pass: until the work ends, asks Ruby, or Ruby wakes the thread. The work is
/// polled before the wake-up, so every pass moves it on however often the thread is
/// woken.
unsafe extern "C" fn run<F>(data: *mut c_void) -> *mut c_void
where
    F: Future + Send + 'static,
    F::Output: Send + 'static,
{
    // SAFETY: only this callback mutates Invocation during the synchronous wait.
    let invocation = unsafe { &mut *data.cast::<Invocation<F>>() };
    // SAFETY: the separate Notify outlives this callback.
    let woken = unsafe { &*invocation.woken };
    // The work finds the questions of this pass on this thread, and nowhere after it.
    let answering = invocation.pass.take().map(hook::enter).is_some();
    let pass = catch_unwind(AssertUnwindSafe(|| {
        invocation.shared.runtime.block_on(async {
            tokio::select! { biased;
                result = invocation.future.as_mut() => Some(result),
                () = hook::asked(), if answering => None,
                () = woken.notified() => None,
            }
        })
    }));
    if answering {
        invocation.pass = hook::leave();
    }
    invocation.result = match pass {
        Ok(result) => result.map(Ok),
        Err(payload) => {
            std::mem::forget(payload);
            Some(Err(()))
        }
    };
    std::ptr::null_mut()
}
