//! Ergonomic facades over the selected, crate-private Progenitor wire clients.
use crate::{Client, Error, Response, classify_transport};
use futures_util::StreamExt;
use progenitor_client::{ByteStream, ResponseValue};
use serde::{Serialize, de::DeserializeOwned};
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
    pub fn into_raw(self) -> Response {
        self.raw
    }
}

pub async fn execute(client: &Client, operation: &str, arguments: &str) -> Result<Response, Error> {
    match operation {
        "catalog_items_2022_04_01.get_catalog_item" => {
            let params = serde_json::from_str(arguments).map_err(|_| Error::InvalidRequest)?;
            Ok(catalog::get_catalog_item(client, params).await?.into_raw())
        }
        "listings_items_2021_08_01.patch_listings_item" => {
            let params: listings::PatchListingsItemParams =
                serde_json::from_str(arguments).map_err(|_| Error::InvalidRequest)?;
            Ok(listings::patch_listings_item(client, params)
                .await?
                .into_raw())
        }
        _ => Err(Error::InvalidRequest),
    }
}

fn validate_segment(value: &str) -> Result<(), Error> {
    if value.is_empty() || matches!(value, "." | "..") {
        Err(Error::InvalidRequest)
    } else {
        Ok(())
    }
}
fn validate_array(values: &[String]) -> Result<(), Error> {
    if values.is_empty() || values.iter().any(|v| v.is_empty() || v.contains(',')) {
        Err(Error::InvalidRequest)
    } else {
        Ok(())
    }
}
fn validate_arrays(required: &[String], optional: &Option<Vec<String>>) -> Result<(), Error> {
    validate_array(required)?;
    if let Some(values) = optional {
        validate_array(values)?;
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

pub mod catalog {
    use super::*;
    use crate::apis::catalog_items_2022_04_01::{metadata, wire};
    #[derive(Debug, serde::Deserialize)]
    #[serde(deny_unknown_fields)]
    pub struct GetCatalogItemParams {
        pub asin: String,
        pub marketplace_ids: Vec<String>,
        #[serde(default = "metadata::included_data_default")]
        pub included_data: Option<Vec<String>>,
        pub locale: Option<String>,
    }
    impl GetCatalogItemParams {
        pub fn new(asin: String, marketplace_ids: Vec<String>) -> Self {
            Self {
                asin,
                marketplace_ids,
                included_data: metadata::included_data_default(),
                locale: None,
            }
        }
    }
    pub async fn get_catalog_item(
        client: &Client,
        params: GetCatalogItemParams,
    ) -> Result<TypedResponse<metadata::ResponseModel>, Error> {
        validate_segment(&params.asin)?;
        validate_arrays(&params.marketplace_ids, &params.included_data)?;
        let wire = wire::Client::new_with_client(
            client.origin.as_str().trim_end_matches('/'),
            client.http.clone(),
            client.clone(),
        );
        let mut request = wire
            .get_catalog_item()
            .asin(params.asin)
            .marketplace_ids(params.marketplace_ids);
        if let Some(included) = params.included_data {
            request = request.included_data(included);
        }
        if let Some(locale) = params.locale {
            request = request.locale(locale);
        }
        Ok(TypedResponse {
            raw: collect(request.send().await).await?,
            model: PhantomData,
        })
    }
}

pub mod listings {
    use super::*;
    use crate::apis::listings_items_2021_08_01::{metadata, wire};
    #[derive(Debug, serde::Deserialize)]
    #[serde(deny_unknown_fields)]
    pub struct PatchListingsItemParams<B = serde_json::Value> {
        pub seller_id: String,
        pub sku: String,
        pub marketplace_ids: Vec<String>,
        pub body: B,
        #[serde(default = "metadata::included_data_default")]
        pub included_data: Option<Vec<String>>,
        pub mode: Option<String>,
        pub issue_locale: Option<String>,
    }
    impl<B> PatchListingsItemParams<B> {
        pub fn new(seller_id: String, sku: String, marketplace_ids: Vec<String>, body: B) -> Self {
            Self {
                seller_id,
                sku,
                marketplace_ids,
                body,
                included_data: metadata::included_data_default(),
                mode: None,
                issue_locale: None,
            }
        }
    }
    pub async fn patch_listings_item<B: Serialize>(
        client: &Client,
        params: PatchListingsItemParams<B>,
    ) -> Result<TypedResponse<metadata::ResponseModel>, Error> {
        validate_segment(&params.seller_id)?;
        validate_segment(&params.sku)?;
        validate_arrays(&params.marketplace_ids, &params.included_data)?;
        let body = serde_json::to_value(params.body).map_err(|_| Error::InvalidRequest)?;
        if !body.is_object() {
            return Err(Error::InvalidRequest);
        }
        let wire = wire::Client::new_with_client(
            client.origin.as_str().trim_end_matches('/'),
            client.http.clone(),
            client.clone(),
        );
        let mut request = wire
            .patch_listings_item()
            .seller_id(params.seller_id)
            .sku(params.sku)
            .marketplace_ids(params.marketplace_ids)
            .body(body);
        if let Some(included) = params.included_data {
            request = request.included_data(included);
        }
        if let Some(mode) = params.mode {
            request = request.mode(mode);
        }
        if let Some(locale) = params.issue_locale {
            request = request.issue_locale(locale);
        }
        Ok(TypedResponse {
            raw: collect(request.send().await).await?,
            model: PhantomData,
        })
    }
}

// Progenitor 0.15.0 supplies an &Client fallback hook implementation. Implementing
// the trait on Client overrides it; this version has no HooksMode::Expected.
macro_rules! wire_hooks {
    ($module:ident) => {
        impl progenitor_client::ClientHooks<crate::Client> for crate::apis::$module::wire::Client {
            async fn pre<E>(
                &self,
                request: &mut reqwest::Request,
                _info: &progenitor_client::OperationInfo,
            ) -> Result<(), progenitor_client::Error<E>> {
                self.inner
                    .prepare_generated(request, crate::apis::$module::metadata::CSV_QUERY_NAMES)
                    .map_err(|_| progenitor_client::Error::InvalidRequest("invalid request".into()))
            }
            async fn exec(
                &self,
                request: reqwest::Request,
                _info: &progenitor_client::OperationInfo,
            ) -> reqwest::Result<reqwest::Response> {
                self.inner.http.execute(request).await
            }
        }
    };
}
wire_hooks!(catalog_items_2022_04_01);
wire_hooks!(listings_items_2021_08_01);

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
        let wire = wire::Client::new_with_client(&base, inner.http.clone(), inner);
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
        let wire = wire::Client::new_with_client(&base, inner.http.clone(), inner);
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
