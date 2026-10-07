//! Native state that only the process that created it may reach or drop. Its fields
//! are private to this module, so `get`, which runs the fork guard, is the only way in.
use super::native_error;
use magnus::{Error, Ruby};
use std::mem::ManuallyDrop;

/// What the caller builds again in a child: the client that a request, a document or
/// an upload came from, or the `Peddler::LWA` that a grant did.
pub(super) const CLIENT: &str = "client";
pub(super) const LWA: &str = "Peddler::LWA";

/// What a native handle holds. Only the process that created it may reach it.
pub(super) struct ForkOwned<T> {
    pid: u32,
    rebuild: &'static str,
    value: ManuallyDrop<T>,
}

impl<T> ForkOwned<T> {
    /// `rebuild` is what the error tells a child to create: `CLIENT` or `LWA`.
    pub(super) fn new(rebuild: &'static str, value: T) -> Self {
        Self {
            pid: std::process::id(),
            rebuild,
            value: ManuallyDrop::new(value),
        }
    }

    /// The value, once the fork guard has passed. There is no other way to it.
    pub(super) fn get(&self, ruby: &Ruby) -> Result<&T, Error> {
        if self.pid != std::process::id() {
            return Err(error(ruby, self.rebuild));
        }
        Ok(&self.value)
    }
}

/// What a child is told of something its parent created: `rebuild` is `CLIENT` or `LWA`.
pub(super) fn error(ruby: &Ruby, rebuild: &str) -> Error {
    let message = format!("create a new {rebuild} after fork");
    native_error(ruby, "ForkError", &message)
}

impl<T> Drop for ForkOwned<T> {
    fn drop(&mut self) {
        if self.pid == std::process::id() {
            // SAFETY: the value is dropped exactly once, only in its creator
            // process. A fork child must leak all inherited state, including the
            // reqwest client, sockets and the runtime: their destructors may touch
            // inherited locks.
            unsafe { ManuallyDrop::drop(&mut self.value) };
        }
    }
}
