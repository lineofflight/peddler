//! Explicit, lazy pagination over generated operations.
//!
//! A [`Pagination`] names the operation, the argument that carries the token
//! and the response field that returns the next one. Nothing is inferred from
//! names at runtime. Each page goes through the normal operation runner, so
//! authorization, rate limits, retries and timeouts apply per page.
use crate::{Client, Error, Response};
use futures_util::{Stream, stream};
use serde_json::{Map, Value};
use std::{collections::HashSet, pin::Pin};

/// A lazy stream of raw pages. Dropping it never fetches another page.
pub type PageStream<'a> =
    Pin<Box<dyn Stream<Item = Result<Response, PaginationError>> + Send + 'a>>;

/// Where the token goes and where the next one comes from.
#[derive(Clone, Debug, PartialEq)]
pub struct Pagination {
    /// Qualified operation key for the first page, e.g. `orders_v0.get_orders`.
    pub operation: String,
    /// JSON pointer into the operation arguments, e.g. `/next_token` or
    /// `/body/nextToken`. Argument keys are native snake_case; body keys keep
    /// the schema's spelling.
    pub input: String,
    /// JSON pointer into the JSON response body, e.g. `/payload/NextToken`.
    pub output: String,
    pub continuation: Continuation,
}

/// How the arguments change after the first page. The default carries every
/// argument over and replaces only the token.
#[derive(Clone, Debug, Default, PartialEq)]
pub struct Continuation {
    /// Operation for pages after the first. Defaults to the first operation.
    pub operation: Option<String>,
    /// When set, only these top-level arguments (plus the token's) survive.
    pub keep: Option<Vec<String>>,
    /// Top-level arguments removed after the first page.
    pub drop: Vec<String>,
    /// Top-level arguments replaced after the first page.
    pub set: Vec<(String, Value)>,
}

impl Pagination {
    pub fn new(
        operation: impl Into<String>,
        input: impl Into<String>,
        output: impl Into<String>,
    ) -> Self {
        Self {
            operation: operation.into(),
            input: input.into(),
            output: output.into(),
            continuation: Continuation::default(),
        }
    }
}

/// Sanitized: never carries tokens, bodies or arguments.
#[derive(Debug, PartialEq, Eq)]
pub enum PaginationError {
    /// The request failed before a response was received.
    Request(Error),
    /// The arguments are not a JSON object or cannot hold the token.
    InvalidArguments,
    /// A pointer in the mapping is malformed.
    InvalidMapping,
    /// A successful page did not have a JSON body.
    MalformedResponse,
    /// The response token was neither absent, null nor a string.
    InvalidToken,
    /// The response token was already seen, including the initial one.
    RepeatedToken,
}

impl std::fmt::Display for PaginationError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.write_str(match self {
            Self::Request(_) => "page request failed",
            Self::InvalidArguments => "invalid pagination arguments",
            Self::InvalidMapping => "invalid pagination mapping",
            Self::MalformedResponse => "malformed pagination response",
            Self::InvalidToken => "invalid pagination token",
            Self::RepeatedToken => "repeated pagination token",
        })
    }
}

impl std::error::Error for PaginationError {
    fn source(&self) -> Option<&(dyn std::error::Error + 'static)> {
        match self {
            Self::Request(error) => Some(error),
            _ => None,
        }
    }
}

enum Step {
    Fetch(Option<String>),
    Fail(PaginationError),
    Done,
}

struct State<'a> {
    client: &'a Client,
    pagination: Pagination,
    arguments: Value,
    input: Vec<String>,
    output: Vec<String>,
    seen: HashSet<String>,
    fetched: usize,
    max_pages: Option<usize>,
    step: Step,
}

/// Streams raw pages of `pagination.operation`.
///
/// `arguments` are serialized once, now, and never mutated. `max_pages` caps
/// the number of requests; `Some(0)` makes none. Nothing is requested until
/// the stream is polled, and pages are fetched one at a time.
pub fn pages<'a, T: serde::Serialize>(
    client: &'a Client,
    pagination: Pagination,
    arguments: &T,
    max_pages: Option<usize>,
) -> PageStream<'a> {
    let mut state = State {
        client,
        arguments: Value::Null,
        input: Vec::new(),
        output: Vec::new(),
        seen: HashSet::new(),
        fetched: 0,
        max_pages,
        step: Step::Fetch(None),
        pagination,
    };
    if let Err(error) = prepare(&mut state, arguments) {
        state.step = Step::Fail(error);
    }
    Box::pin(stream::unfold(state, next_page))
}

fn prepare<T: serde::Serialize>(
    state: &mut State<'_>,
    arguments: &T,
) -> Result<(), PaginationError> {
    state.input = segments(&state.pagination.input)?;
    state.output = segments(&state.pagination.output)?;
    state.arguments =
        serde_json::to_value(arguments).map_err(|_| PaginationError::InvalidArguments)?;
    if !state.arguments.is_object() {
        return Err(PaginationError::InvalidArguments);
    }
    match state.arguments.pointer(&state.pagination.input) {
        None | Some(Value::Null) => {}
        Some(Value::String(token)) if token.is_empty() => {}
        Some(Value::String(token)) => {
            state.seen.insert(token.clone());
        }
        Some(_) => return Err(PaginationError::InvalidArguments),
    }
    Ok(())
}

fn segments(pointer: &str) -> Result<Vec<String>, PaginationError> {
    let rest = pointer
        .strip_prefix('/')
        .ok_or(PaginationError::InvalidMapping)?;
    Ok(rest
        .split('/')
        .map(|part| part.replace("~1", "/").replace("~0", "~"))
        .collect())
}

fn continuation_arguments(state: &State<'_>, token: &str) -> Result<Value, PaginationError> {
    let continuation = &state.pagination.continuation;
    let mut arguments: Map<String, Value> = state
        .arguments
        .as_object()
        .cloned()
        .ok_or(PaginationError::InvalidArguments)?;
    if let Some(keep) = &continuation.keep {
        arguments.retain(|key, _| *key == state.input[0] || keep.contains(key));
    }
    for key in &continuation.drop {
        if *key != state.input[0] {
            arguments.remove(key);
        }
    }
    for (key, value) in &continuation.set {
        arguments.insert(key.clone(), value.clone());
    }
    let mut node = &mut arguments;
    let (last, parents) = state.input.split_last().expect("pointer has a segment");
    for key in parents {
        node = node
            .entry(key.clone())
            .or_insert_with(|| Value::Object(Map::new()))
            .as_object_mut()
            .ok_or(PaginationError::InvalidArguments)?;
    }
    node.insert(last.clone(), Value::String(token.to_owned()));
    Ok(Value::Object(arguments))
}

fn extract(output: &[String], body: &[u8]) -> Result<Option<String>, PaginationError> {
    let value: Value =
        serde_json::from_slice(body).map_err(|_| PaginationError::MalformedResponse)?;
    let mut node = &value;
    for key in output {
        match node.get(key.as_str()) {
            Some(next) => node = next,
            None => return Ok(None),
        }
    }
    match node {
        Value::Null => Ok(None),
        Value::String(token) if token.is_empty() => Ok(None),
        Value::String(token) => Ok(Some(token.clone())),
        _ => Err(PaginationError::InvalidToken),
    }
}

async fn next_page(mut state: State<'_>) -> Option<(Result<Response, PaginationError>, State<'_>)> {
    let token = match std::mem::replace(&mut state.step, Step::Done) {
        Step::Done => return None,
        Step::Fail(error) => return Some((Err(error), state)),
        Step::Fetch(token) => token,
    };
    if state.max_pages.is_some_and(|max| state.fetched >= max) {
        return None;
    }
    let (operation, arguments) = match &token {
        None => (
            state.pagination.operation.clone(),
            Ok(state.arguments.clone()),
        ),
        Some(token) => (
            state
                .pagination
                .continuation
                .operation
                .clone()
                .unwrap_or_else(|| state.pagination.operation.clone()),
            continuation_arguments(&state, token),
        ),
    };
    let arguments = match arguments.and_then(|value| {
        serde_json::to_string(&value).map_err(|_| PaginationError::InvalidArguments)
    }) {
        Ok(arguments) => arguments,
        Err(error) => return Some((Err(error), state)),
    };
    let response = match crate::apis::execute(state.client, &operation, &arguments).await {
        Ok(response) => response,
        Err(error) => return Some((Err(PaginationError::Request(error)), state)),
    };
    state.fetched += 1;
    let capped = state.max_pages.is_some_and(|max| state.fetched >= max);
    // An HTTP error page is yielded once and ends the stream.
    if !capped && (200..300).contains(&response.status) {
        state.step = match extract(&state.output, &response.body) {
            Ok(None) => Step::Done,
            Ok(Some(token)) if state.seen.insert(token.clone()) => Step::Fetch(Some(token)),
            Ok(Some(_)) => Step::Fail(PaginationError::RepeatedToken),
            Err(error) => Step::Fail(error),
        };
    }
    Some((Ok(response), state))
}
