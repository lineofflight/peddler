//! Shared raw response collection and pre-authorization facade validation.
use crate::{Client, Error, Response, classify_transport};
use futures_util::StreamExt;
use progenitor_client::{ByteStream, ResponseValue};
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

/// Per-attempt context: Progenitor 0.15 drops empty query arrays and treats all
/// request bodies as required. Adapt only these omissions in the shared pre hook.
#[derive(Clone, Debug)]
pub struct WireContext {
    pub client: Client,
    pub empty_queries: Vec<&'static str>,
    pub omit_body: bool,
}
impl From<Client> for WireContext {
    fn from(client: Client) -> Self {
        Self {
            client,
            empty_queries: Vec::new(),
            omit_body: false,
        }
    }
}
impl WireContext {
    pub fn prepare(&self, request: &mut reqwest::Request, csv: &[&str]) -> Result<(), Error> {
        self.client.prepare_generated(request, csv)?;
        if self.omit_body {
            *request.body_mut() = None;
            for header in [
                reqwest::header::CONTENT_TYPE,
                reqwest::header::CONTENT_LENGTH,
                reqwest::header::TRANSFER_ENCODING,
            ] {
                request.headers_mut().remove(header);
            }
        }
        if !self.empty_queries.is_empty() {
            request
                .url_mut()
                .query_pairs_mut()
                .extend_pairs(self.empty_queries.iter().map(|name| (*name, "")));
        }
        Ok(())
    }
}

/// Validate schema parameter constraints before acquiring authorization. String
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

pub(crate) async fn collect(
    result: Result<ResponseValue<ByteStream>, progenitor_client::Error<ByteStream>>,
) -> Result<Response, Error> {
    use progenitor_client::Error as WireError;
    let response = match result {
        Ok(response) | Err(WireError::ErrorResponse(response)) => response,
        Err(WireError::UnexpectedResponse(response)) => ResponseValue::stream(response),
        Err(
            WireError::CommunicationError(error)
            | WireError::ResponseBodyError(error)
            | WireError::InvalidUpgrade(error),
        ) => return Err(classify_transport(error)),
        Err(WireError::InvalidRequest(_)) => return Err(Error::InvalidRequest),
        Err(_) => return Err(Error::Transport),
    };
    let status = response.status().as_u16();
    let headers = response
        .headers()
        .iter()
        .map(|(name, value)| {
            (
                name.as_str().to_owned(),
                String::from_utf8_lossy(value.as_bytes()).into_owned(),
            )
        })
        .collect();
    let mut stream = response.into_inner_stream();
    let mut body = Vec::new();
    while let Some(chunk) = stream.next().await {
        body.extend_from_slice(&chunk.map_err(classify_transport)?);
    }
    Ok(Response {
        status,
        headers,
        body,
    })
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::apis::catalog_items_2022_04_01::wire;
    use progenitor_client::{ClientHooks, OperationInfo};
    use std::time::Duration;
    use tokio::{
        io::{AsyncReadExt, AsyncWriteExt},
        net::TcpListener,
    };

    #[tokio::test]
    async fn foreign_generated_origin_is_rejected_before_network_or_token_injection() {
        let home = TcpListener::bind("127.0.0.1:0").await.unwrap();
        let foreign = TcpListener::bind("127.0.0.1:0").await.unwrap();
        let inner = Client::new(
            &format!("http://{}", home.local_addr().unwrap()),
            "origin-secret",
        )
        .unwrap();
        let base = format!("http://{}", foreign.local_addr().unwrap());
        let mut inner = inner;
        inner.access_token = Some(inner.auth.token(None).await.unwrap());
        let wire = wire::Client::new_with_client(&base, inner.http.clone(), inner.into());
        let mut request =
            reqwest::Request::new(reqwest::Method::GET, reqwest::Url::parse(&base).unwrap());
        let info = OperationInfo {
            operation_id: "get_catalog_item",
        };
        let result = wire.pre::<ByteStream>(&mut request, &info).await;
        assert!(matches!(
            result,
            Err(progenitor_client::Error::InvalidRequest(_))
        ));
        assert!(!request.headers().contains_key("x-amz-access-token"));
        let result = tokio::time::timeout(
            Duration::from_millis(100),
            wire.get_catalog_item()
                .asin("X")
                .marketplace_ids(vec!["UK".to_owned()])
                .send(),
        )
        .await
        .unwrap();
        assert_eq!(collect(result).await.unwrap_err(), Error::InvalidRequest);
        assert!(
            tokio::time::timeout(Duration::from_millis(20), foreign.accept())
                .await
                .is_err()
        );
    }
    #[tokio::test]
    async fn generated_request_timeout_override_cannot_bypass_shared_timeout() {
        let listener = TcpListener::bind("127.0.0.1:0").await.unwrap();
        let base = format!("http://{}", listener.local_addr().unwrap());
        let inner =
            Client::with_timeout(&base, "timeout-secret", Duration::from_millis(30)).unwrap();
        let mut inner = inner;
        inner.access_token = Some(inner.auth.token(None).await.unwrap());
        let wire = wire::Client::new_with_client(&base, inner.http.clone(), inner.into());
        let mut request =
            reqwest::Request::new(reqwest::Method::GET, reqwest::Url::parse(&base).unwrap());
        *request.timeout_mut() = Some(Duration::from_secs(20));
        wire.pre::<ByteStream>(
            &mut request,
            &OperationInfo {
                operation_id: "get_catalog_item",
            },
        )
        .await
        .unwrap();
        let task = tokio::spawn(async move {
            let (mut socket, _) = listener.accept().await.unwrap();
            let mut bytes = [0; 4096];
            assert!(socket.read(&mut bytes).await.unwrap() > 0);
            socket
                .write_all(b"HTTP/1.1 200 OK\r\nContent-Length: 2\r\n\r\nx")
                .await
                .unwrap();
            tokio::time::sleep(Duration::from_secs(5)).await;
        });
        let result = tokio::time::timeout(Duration::from_millis(250), async {
            collect(
                wire.exec(
                    request,
                    &OperationInfo {
                        operation_id: "get_catalog_item",
                    },
                )
                .await
                .map(ResponseValue::stream)
                .map_err(progenitor_client::Error::CommunicationError),
            )
            .await
        })
        .await
        .unwrap();
        assert_eq!(result.unwrap_err(), Error::Timeout);
        task.abort();
    }
}
