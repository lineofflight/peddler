//! Native state that only the process that created it may reach or drop. Its fields
//! are private to this module, so `get`, which runs the fork guard, is the only way in.
use super::native_error;
use magnus::{Error, Ruby};
use std::mem::ManuallyDrop;

/// What a native handle holds. Only the process that created it may reach it.
pub(super) struct ForkOwned<T> {
    pid: u32,
    value: ManuallyDrop<T>,
}

impl<T> ForkOwned<T> {
    pub(super) fn new(value: T) -> Self {
        Self {
            pid: std::process::id(),
            value: ManuallyDrop::new(value),
        }
    }

    /// The value, once the fork guard has passed. There is no other way to it.
    pub(super) fn get(&self, ruby: &Ruby) -> Result<&T, Error> {
        if self.pid != std::process::id() {
            return Err(native_error(
                ruby,
                "ForkError",
                "create a new client after fork",
            ));
        }
        Ok(&self.value)
    }
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
