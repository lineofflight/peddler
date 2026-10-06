//! What generated operations share: typed responses and the parts of a request.
use crate::{Error, Response};
use serde::de::DeserializeOwned;
use std::marker::PhantomData;

#[derive(Debug)]
pub struct TypedResponse<T> {
    pub raw: Response,
    model: PhantomData<T>,
}
impl<T: DeserializeOwned> TypedResponse<T> {
    pub fn json(&self) -> Result<T, serde_json::Error> {
        serde_json::from_slice(&self.raw.body)
    }
}
impl<T> TypedResponse<T> {
    pub(crate) fn new(raw: Response) -> Self {
        Self {
            raw,
            model: PhantomData,
        }
    }
    pub fn into_raw(self) -> Response {
        self.raw
    }
}
#[derive(Debug)]
pub enum DecodeError {
    UnexpectedStatus { expected: u16, actual: u16 },
    Json(serde_json::Error),
}
impl std::fmt::Display for DecodeError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Self::UnexpectedStatus { expected, actual } => {
                write!(f, "expected status {expected}, received {actual}")
            }
            Self::Json(error) => error.fmt(f),
        }
    }
}
impl std::error::Error for DecodeError {}
pub(crate) fn decode_status<T: DeserializeOwned>(
    raw: &Response,
    expected: u16,
) -> Result<T, DecodeError> {
    if raw.status != expected {
        return Err(DecodeError::UnexpectedStatus {
            expected,
            actual: raw.status,
        });
    }
    serde_json::from_slice(&raw.body).map_err(DecodeError::Json)
}

/// Query parameters or headers, in the order they are sent.
type Pairs = Vec<(String, String)>;

/// Percent-encodes a path argument as one segment. A dot segment is refused: URL
/// parsing would resolve it away and the request would reach another resource.
pub(crate) fn segment(value: &str) -> Result<String, Error> {
    if matches!(value, "." | "..") {
        return Err(Error::InvalidRequest);
    }
    Ok(percent_encoding::utf8_percent_encode(value, crate::url::SEGMENT).to_string())
}

/// Adds a header or a scalar query parameter that was given.
pub(crate) fn pair(pairs: &mut Pairs, name: &str, value: Option<&impl ToString>) {
    if let Some(value) = value {
        pairs.push((name.to_owned(), value.to_string()));
    }
}

/// Adds an array as one comma-separated value. `empty` adds an empty one.
pub(crate) fn csv(query: &mut Pairs, name: &str, values: Option<&Vec<String>>) {
    if let Some(values) = values.filter(|values| !values.is_empty()) {
        query.push((name.to_owned(), values.join(",")));
    }
}

/// Adds an array as one parameter per value.
pub(crate) fn repeated(query: &mut Pairs, name: &str, values: Option<&Vec<String>>) {
    for value in values.into_iter().flatten() {
        query.push((name.to_owned(), value.clone()));
    }
}

/// Adds an empty array as `name=`, so that it is sent and not dropped.
pub(crate) fn empty(query: &mut Pairs, name: &str, values: Option<&Vec<String>>) {
    if values.is_some_and(Vec::is_empty) {
        query.push((name.to_owned(), String::new()));
    }
}

pub(crate) fn json(body: &impl serde::Serialize) -> Result<Vec<u8>, Error> {
    serde_json::to_vec(body).map_err(|_| Error::InvalidRequest)
}
