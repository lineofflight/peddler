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

/// Validate schema parameter constraints before any request. String
/// enums stay open; formats and patterns constrain the actual wire representation.
pub(crate) fn validate_parameter(
    value: serde_json::Value,
    location: &str,
    schema: &str,
    required: bool,
    csv: bool,
) -> Result<(), Error> {
    let schema: serde_json::Value =
        serde_json::from_str(schema).map_err(|_| Error::InvalidRequest)?;
    validate_value(&value, location, &schema, required, csv)
}
fn validate_value(
    value: &serde_json::Value,
    location: &str,
    schema: &serde_json::Value,
    required: bool,
    csv: bool,
) -> Result<(), Error> {
    let invalid = || Error::InvalidRequest;
    match schema["type"].as_str() {
        Some("array") => {
            let values = value.as_array().ok_or_else(invalid)?;
            let minimum = schema["minItems"].as_u64().unwrap_or(u64::from(required));
            if values.len() < minimum as usize {
                return Err(invalid());
            }
            if let Some(maximum) = schema["maxItems"].as_u64()
                && values.len() > maximum as usize
            {
                return Err(invalid());
            }
            for value in values {
                if value
                    .as_str()
                    .is_none_or(|s| s.is_empty() || (csv && s.contains(',')))
                {
                    return Err(invalid());
                }
                validate_value(value, "query", &schema["items"], false, false)?;
            }
        }
        Some("string") => {
            let text = value.as_str().ok_or_else(invalid)?;
            if location == "path" && (text.is_empty() || matches!(text, "." | "..")) {
                return Err(invalid());
            }
            let length = text.chars().count() as u64;
            if schema["minLength"].as_u64().is_some_and(|min| length < min)
                || schema["maxLength"].as_u64().is_some_and(|max| length > max)
            {
                return Err(invalid());
            }
            match schema["format"].as_str() {
                Some("date-time") if chrono::DateTime::parse_from_rfc3339(text).is_err() => {
                    return Err(invalid());
                }
                Some("date")
                    if text.len() != 10
                        || chrono::NaiveDate::parse_from_str(text, "%Y-%m-%d").is_err() =>
                {
                    return Err(invalid());
                }
                Some("[A-Z]{2}")
                    if text.len() != 2 || !text.bytes().all(|b| b.is_ascii_uppercase()) =>
                {
                    return Err(invalid());
                }
                _ => (),
            }
            if let Some(pattern) = schema["pattern"].as_str()
                && regress::Regex::new(pattern)
                    .map_err(|_| invalid())?
                    .find(text)
                    .is_none()
            {
                return Err(invalid());
            }
        }
        Some("boolean") if !value.is_boolean() => return Err(invalid()),
        Some("integer" | "number") => {
            let number = value
                .as_f64()
                .filter(|n| n.is_finite())
                .ok_or_else(invalid)?;
            if schema["minimum"].as_f64().is_some_and(|min| {
                number < min || (schema["exclusiveMinimum"] == true && number == min)
            }) || schema["maximum"].as_f64().is_some_and(|max| {
                number > max || (schema["exclusiveMaximum"] == true && number == max)
            }) {
                return Err(invalid());
            }
        }
        _ => (),
    }
    if location == "header"
        && reqwest::header::HeaderValue::from_str(value.as_str().unwrap_or("")).is_err()
    {
        return Err(invalid());
    }
    Ok(())
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
