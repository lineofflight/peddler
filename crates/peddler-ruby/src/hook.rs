//! Ruby, called in the middle of a native call.
//!
//! The work of a call owns Rust data only and is polled without the GVL, so it never
//! calls Ruby. It parks a question and waits for the answer. Parking ends the pass, and
//! `gvl::asking` answers between passes, on the calling thread with the GVL held: it
//! calls a token source for the token of an attempt, and the exchange hook, which the
//! WebMock adapter sets, for a request the work would send.
//!
//! A question is parked in a slot of the calling thread that exists only during a pass
//! of a call that answers. Anywhere else, on a runtime thread or in a call that asks
//! nothing, there is no slot: the exchange goes to the network and a token is refused.

use super::{ACCESS_TOKEN, argument_error, peddler_const};
use magnus::{
    Error, RArray, RModule, RString, Ruby, Symbol, TryConvert, Value, method, prelude::*,
};
use peddler::{
    Response,
    auth::AuthError,
    intercept::{Exchange, Failure, Interceptor, Reply},
};
use std::{
    cell::RefCell,
    collections::VecDeque,
    sync::atomic::{AtomicBool, Ordering},
};
use tokio::sync::oneshot;

/// What the work asks of Ruby.
pub(super) enum Question {
    /// The access token of an attempt.
    Token,
    /// What to do with a request the work is about to send.
    Exchange(Exchange),
    /// The response of a request that went to the network after all.
    Completed(Response),
}

/// What Ruby answered.
pub(super) enum Answer {
    Token(String),
    /// The response: a stubbed one to an exchange, or the real one given back.
    Reply(Response),
    /// The exchange times out.
    TimedOut,
    /// The request goes to the network.
    Proceed,
    /// The call has nothing to answer the question with.
    Refused,
}

type Parked = (Question, oneshot::Sender<Answer>);

/// The questions of one pass, and whether the call hands its exchanges to the hook.
pub(super) struct Pass {
    parked: VecDeque<Parked>,
    exchanges: bool,
}

impl Pass {
    /// The next question the work still waits on.
    pub(super) fn next(&mut self) -> Option<Parked> {
        loop {
            let parked = self.parked.pop_front()?;
            // An attempt that timed out, say, dropped the question it had parked.
            if !parked.1.is_closed() {
                return Some(parked);
            }
        }
    }
}

thread_local! {
    static PASS: RefCell<Option<Pass>> = const { RefCell::new(None) };
}

/// Opens the slot of the calling thread for one pass.
pub(super) fn enter(pass: Pass) {
    PASS.with(|slot| *slot.borrow_mut() = Some(pass));
}

/// Closes the slot and returns it with what the work parked.
pub(super) fn leave() -> Option<Pass> {
    PASS.with(|slot| slot.borrow_mut().take())
}

/// Ready once the work has parked a question. The work is polled first in every pass,
/// so there is nothing to be woken for.
pub(super) async fn asked() {
    std::future::poll_fn(|_| {
        let parked = PASS.with(|slot| {
            slot.borrow()
                .as_ref()
                .is_some_and(|pass| !pass.parked.is_empty())
        });
        if parked {
            std::task::Poll::Ready(())
        } else {
            std::task::Poll::Pending
        }
    })
    .await;
}

/// Parks a question and waits for its answer. None where nothing answers.
async fn ask(question: Question) -> Option<Answer> {
    let (reply, answer) = oneshot::channel();
    PASS.with(|slot| {
        let mut slot = slot.borrow_mut();
        slot.as_mut()?.parked.push_back((question, reply));
        Some(())
    })?;
    answer.await.ok()
}

/// The token source of a client that has no token of its own: Ruby is asked before
/// every attempt. A client nothing answers for has no token to send and fails closed.
pub(super) async fn token() -> Result<String, AuthError> {
    match ask(Question::Token).await {
        Some(Answer::Token(token)) => Ok(token),
        _ => Err(AuthError::InvalidConfig),
    }
}

/// The interceptor of the shared pool. It takes the exchanges of a call that began
/// while an exchange hook was set.
pub(super) struct Hook;

impl Interceptor for Hook {
    fn enabled(&self) -> bool {
        PASS.with(|slot| slot.borrow().as_ref().is_some_and(|pass| pass.exchanges))
    }

    fn exchange<'a>(&'a self, exchange: Exchange, real: Reply<'a>) -> Reply<'a> {
        Box::pin(async move {
            match ask(Question::Exchange(exchange)).await {
                Some(Answer::Reply(response)) => Ok(response),
                Some(Answer::TimedOut) => Err(Failure::Timeout),
                Some(Answer::Proceed) => {
                    let response = real.await?;
                    match ask(Question::Completed(response)).await {
                        Some(Answer::Reply(response)) => Ok(response),
                        _ => Err(Failure::Transport),
                    }
                }
                _ => Err(Failure::Transport),
            }
        })
    }
}

/// Whether an exchange hook is set, so that a call without one doesn't look for it.
static HOOKED: AtomicBool = AtomicBool::new(false);
/// The instance variable of `Peddler::Native` that holds the hook.
const HOOK: &str = "@exchange_hook";

pub(super) fn hooked() -> bool {
    HOOKED.load(Ordering::Acquire)
}

/// `Peddler::Native.exchange_hook = hook`, or nil for none. The hook answers
/// `call(method, url, headers, body)` with `[status, headers, body]` for a response,
/// `:timeout`, or anything else to let the request go out, which it gets back in
/// `completed(ticket, status, headers, body)` with the real response.
fn set(native: RModule, hook: Value) -> Result<Value, Error> {
    native.ivar_set(HOOK, hook)?;
    HOOKED.store(!hook.is_nil(), Ordering::Release);
    Ok(hook)
}

/// What answers the questions of one call. It lives on the stack of the call, where the
/// collector sees what it holds, and the work never has it.
pub(super) struct Responder {
    source: Option<Value>,
    hook: Option<Value>,
    /// What the hook returned for the request that is on the network.
    ticket: Option<Value>,
}

impl Responder {
    /// None for a call that asks Ruby nothing: no token source and no exchange hook.
    pub(super) fn new(ruby: &Ruby, source: Option<Value>) -> Result<Option<Self>, Error> {
        let hook = if hooked() {
            peddler_const::<RModule>(ruby, "Native")?.ivar_get::<_, Option<Value>>(HOOK)?
        } else {
            None
        };
        Ok((source.is_some() || hook.is_some()).then_some(Self {
            source,
            hook,
            ticket: None,
        }))
    }

    pub(super) fn pass(&self) -> Pass {
        Pass {
            parked: VecDeque::new(),
            exchanges: self.hook.is_some(),
        }
    }

    /// Calls Ruby for the answer. What Ruby raises ends the call.
    pub(super) fn answer(&mut self, ruby: &Ruby, question: Question) -> Result<Answer, Error> {
        match (question, self.source, self.hook) {
            (Question::Token, Some(source), _) => {
                let token: Value = source.funcall("call", ())?;
                // Raises the fixed ArgumentError that a token given to the client gets.
                let token: String =
                    peddler_const::<RModule>(ruby, "Native")?.funcall("access_token", (token,))?;
                // As the core takes a token: not blank, and a header value.
                if token.trim().is_empty() || http::HeaderValue::from_str(&token).is_err() {
                    return Err(argument_error(ruby, ACCESS_TOKEN));
                }
                Ok(Answer::Token(token))
            }
            (Question::Exchange(exchange), _, Some(hook)) => {
                let body = ruby.str_from_slice(&exchange.body);
                let arguments = (exchange.method, exchange.url, exchange.headers, body);
                let verdict: Value = hook.funcall("call", arguments)?;
                if let Some(reply) = RArray::from_value(verdict) {
                    let (status, headers, body): (u16, Vec<(String, String)>, RString) =
                        TryConvert::try_convert(reply.as_value())?;
                    // SAFETY: the GVL is held and the bytes are copied before Ruby runs again.
                    let body = unsafe { body.as_slice().to_vec() };
                    return Ok(Answer::Reply(Response {
                        status,
                        headers: lowercase(headers),
                        body,
                    }));
                }
                if Symbol::from_value(verdict)
                    .is_some_and(|symbol| symbol.name().is_ok_and(|name| name == "timeout"))
                {
                    return Ok(Answer::TimedOut);
                }
                self.ticket = Some(verdict);
                Ok(Answer::Proceed)
            }
            (Question::Completed(response), _, Some(hook)) => {
                let body = ruby.str_from_slice(&response.body);
                let arguments = (
                    self.ticket.take(),
                    response.status,
                    response.headers.clone(),
                    body,
                );
                let _: Value = hook.funcall("completed", arguments)?;
                Ok(Answer::Reply(response))
            }
            _ => Ok(Answer::Refused),
        }
    }
}

/// Header names as the core keeps those of a response.
fn lowercase(headers: Vec<(String, String)>) -> Vec<(String, String)> {
    headers
        .into_iter()
        .map(|(name, value)| (name.to_ascii_lowercase(), value))
        .collect()
}

pub(super) fn init(native: RModule) -> Result<(), Error> {
    native.define_singleton_method("exchange_hook=", method!(set, 1))?;
    Ok(())
}
