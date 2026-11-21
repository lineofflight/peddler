# peddler

A Rust client for Amazon's [Selling Partner API (SP-API)][api-docs]. It is the Rust half of Peddler, and the core of the Ruby gem on the repository's [front page][gem]. It works on its own.

The crate provides:

- all 394 SP-API operations in 73 API versions, each an async function with typed parameters, and a typed response where Amazon's model defines one
- typed models for reports, feeds, notifications and Data Kiosk schemas
- Login with Amazon (LWA) token requests and an optional in-process token source
- retries for throttled and failed requests, off by default
- pagination as a stream of pages
- streaming downloads and uploads of documents, with GZIP, TSV and JSON Lines
- helpers that wait for a report, feed or query and fetch its document

The client is thin. It sends the access token it is given over a shared connection pool. It doesn't request, refresh or cache a token, and it doesn't pace calls.

## Installation

Calls are async and run on [Tokio](https://tokio.rs). The crate needs Rust 1.88 or later.

```toml
[dependencies]
peddler = "0.1"
tokio = { version = "1", features = ["macros", "rt-multi-thread"] }
futures-util = "0.3"
serde_json = "1"
bytes = "1"
```

`futures-util` reads the streams of pages and documents, `serde_json` builds request bodies, and `bytes` holds the chunks of an upload. Leave out what you don't use.

The examples below run inside an async function that returns `Result<(), Box<dyn std::error::Error>>`.

## The client

Create a client with the endpoint of the seller's region and an access token.

```rust
use peddler::Client;

let client = Client::new("https://sellingpartnerapi-eu.amazon.com", "Atza|...")?;
```

| Region | Endpoint |
| --- | --- |
| North America | `https://sellingpartnerapi-na.amazon.com` |
| Europe | `https://sellingpartnerapi-eu.amazon.com` |
| Far East | `https://sellingpartnerapi-fe.amazon.com` |

Put `sandbox.` before the host for Amazon's sandbox. The base URL takes no path. Plain `http` is accepted for `localhost` and loopback addresses only, so that a token is never sent unencrypted over a network.

`ClientConfig` sets the rest: the timeout of an attempt, retries, a `User-Agent` of your own and a connection pool to share.

```rust
use peddler::{Client, ClientConfig, policy::RetryPolicy};
use std::time::Duration;

let mut config = ClientConfig::new("https://sellingpartnerapi-eu.amazon.com", "Atza|...");
config.timeout = Duration::from_secs(60);
config.retry = RetryPolicy { max_retries: 3 };
let client = Client::with_config(config)?;
```

A client is cheap to clone, and clones share its connection pool. `with_access_token` returns a clone that sends another token, for another seller or a restricted data token.

```rust
let other = client.with_access_token("Atza|another-seller")?;
```

Clients created separately each open a pool. To share one, create a `Pool` and set it as `ClientConfig::pool`.

## Operations

Each API version is a module under `peddler::apis`. Each operation is an async function that takes the client and a parameter struct. The struct's `new` takes the required parameters, and the optional ones are public fields.

```rust
use peddler::apis::orders_v0;

let mut params = orders_v0::GetOrdersParams::new(vec!["A1F83G8C2ARO7P".into()]);
params.created_after = Some("2026-01-01T00:00:00Z".into());
params.order_statuses = Some(vec!["Unshipped".into(), "PartiallyShipped".into()]);

let response = orders_v0::get_orders(&client, params).await?;
println!("{}", response.raw.status);
```

The function returns once Amazon has answered, whatever the status. An HTTP error status is a response, not an `Err`. `response.raw` is the `Response`, with `status`, `headers` and `body`. `json()` decodes the body into the operation's model when you ask for it.

```rust
use peddler::apis::orders_v0;

let params = orders_v0::GetOrdersParams::new(vec!["A1F83G8C2ARO7P".into()]);
let response = orders_v0::get_orders(&client, params).await?;
if response.raw.status == 200 {
    if let Some(payload) = response.json()?.payload {
        for order in payload.orders.iter() {
            println!("{} {:?}", order.amazon_order_id, order.order_status);
        }
    }
}
```

`error_for_status` turns a response outside 2xx into an `ApiError`. It keeps the response and reads Amazon's error `code` and `message` and the `request_id` from it.

```rust
use peddler::apis::orders_v0;

let params = orders_v0::GetOrderParams::new("123-1234567-1234567".into());
match orders_v0::get_order(&client, params).await?.into_raw().error_for_status() {
    Ok(response) => println!("{} bytes", response.body.len()),
    Err(error) if error.response.status == 429 => println!("throttled, request {:?}", error.request_id),
    Err(error) => println!("{:?}: {:?}", error.code, error.message),
}
```

A request body is the last argument of `new`. Pass a `serde_json::Value` or any type that serializes to the body Amazon documents.

```rust
use peddler::apis::reports_2021_06_30 as reports;

let body = serde_json::json!({
    "reportType": "GET_MERCHANT_LISTINGS_ALL_DATA",
    "marketplaceIds": ["A1F83G8C2ARO7P"],
});
let response = reports::create_report(&client, reports::CreateReportParams::new(body)).await?;
let report_id = response.json()?.report_id;
```

Parameters are sent as given. The crate doesn't check them against Amazon's schemas: Amazon does, and answers 400. With `Error::InvalidRequest`, it refuses what it can't send as the request you mean: `.` or `..` as a path parameter, an empty parameter at the end of a path, and a header value that HTTP doesn't allow.

An operation with more than one successful response has a decoder for each status, such as `json_200` and `json_202` on Fulfillment Outbound's `create_order`. An operation whose response Amazon doesn't model returns the `Response` itself.

For a call the crate has no function for, send a `Request` with `client.execute`.

```rust
let response = client
    .execute(peddler::Request {
        method: "GET".into(),
        path: "/sellers/v1/marketplaceParticipations".into(),
        query: vec![],
        headers: vec![],
        body: None,
    })
    .await?;
println!("{}", response.status);
```

## Tokens and LWA

`LwaClient` requests tokens from Login with Amazon. Each call makes one request and keeps nothing.

```rust
use peddler::auth::LwaClient;

let lwa = LwaClient::new("amzn1.application-oa2-client...", "amzn1.oa2-cs.v1...")?;

// A seller's refresh token, from the authorization code of your website's consent flow
let tokens = lwa.exchange_authorization_code("code", Some("https://example.com/callback")).await?;
let refresh_token = tokens.refresh_token.ok_or("no refresh token")?;

// An access token, valid for tokens.expires_in seconds
let tokens = lwa.refresh(&refresh_token).await?;
let client = peddler::Client::new("https://sellingpartnerapi-eu.amazon.com", &tokens.access_token)?;

// An access token for grantless operations
let grantless = lwa.client_credentials("sellingpartnerapi::notifications").await?;
```

`LwaTokens` has `access_token`, `refresh_token`, `token_type`, `expires_in` and `scope`, and hides its tokens in `Debug`. A rejection is `AuthError::Rejected { status, code }`, where `code` is what Amazon names, such as `invalid_grant`.

An access token lasts 1 hour. In place of a fixed token, give the client a `TokenSource`: an async closure that returns the token. The client asks it before every attempt and keeps nothing it returns, so the closure decides where tokens live. Read them from a cache that your processes share.

```rust
use peddler::{Client, ClientConfig, auth::{AuthError, TokenSource}};

let source = TokenSource::new(|| async {
    // Read the token from your cache, and request a new one when it has none.
    Ok::<_, AuthError>(String::from("Atza|..."))
});
let client = Client::with_config(ClientConfig::new("https://sellingpartnerapi-eu.amazon.com", source))?;
```

In a single process, `LwaClient` has a source ready. It keeps one access token in memory, requests the next one 60 seconds before the old one expires and makes one request at a time, however many tasks ask.

```rust
use peddler::{Client, ClientConfig};

let source = lwa.source_for_refresh_token("Atzr|...")?;
let client = Client::with_config(ClientConfig::new("https://sellingpartnerapi-eu.amazon.com", source))?;
```

`source_for_scope` does the same for grantless operations.

For a restricted operation, create a restricted data token and send it through a view of the client.

```rust
use peddler::apis::{orders_v0, tokens_2021_03_01 as tokens};

let body = serde_json::json!({
    "restrictedResources": [
        { "method": "GET", "path": "/orders/v0/orders/123-1234567-1234567/address" }
    ]
});
let created = tokens::create_restricted_data_token(&client, tokens::CreateRestrictedDataTokenParams::new(body)).await?;
let token = created.json()?.restricted_data_token.ok_or("no restricted data token")?;

let restricted = client.with_access_token(&token)?;
let params = orders_v0::GetOrderAddressParams::new("123-1234567-1234567".into());
let address = orders_v0::get_order_address(&restricted, params).await?;
```

## Retries and timeouts

A client makes one attempt and allows it 30 seconds, unless `ClientConfig` says otherwise. A timeout of zero, or one too long to set a deadline by, is refused with `Error::InvalidRequest` when the client is built.

`RetryPolicy { max_retries }` is all there is to configure: how often a call is retried, 10 times at most. What is retried and how long each wait is are fixed. The waits are those of Peddler 5 for Ruby.

The client retries a request that Amazon answers with 429, whatever its method: a throttled request was not processed.

It also retries a GET, a HEAD or an OPTIONS that Amazon answers with 500, 502, 503 or 504, that got no response, or that ran past the timeout. The generated operations use GET of these. It never retries another method after these, since Amazon may have processed the request, and a second one could submit a feed or an order twice.

After a 429, the client waits by the rate Amazon documents for the operation: 1 / rate seconds before the first retry, twice that before the second, and so on, plus up to 0.1 seconds. An operation limited to 0.5 requests a second waits 2, 4 and 8 seconds. One limited to 1 request a minute waits 60, 120 and 240. On a host that starts with `sandbox.`, the first wait is 0.2 seconds, whatever the rate.

Each generated function carries the rate of its operation, read from the usage plan in Amazon's model. `operation-inventory.json` in `peddler-codegen` lists them. The client doesn't read the limit that the headers of a response carry.

If Amazon gave a seller another limit, `with_rate_limit` returns a view of the client that waits by the rate you give, in requests per second.

```rust
use peddler::apis::orders_v0;

let fast = client.with_rate_limit(Some(0.5))?;
let params = orders_v0::GetOrdersParams::new(vec!["A1F83G8C2ARO7P".into()]);
let response = orders_v0::get_orders(&fast, params).await?;
```

The view's rate replaces the documented one for every call made through it, and gives one to a `Request` sent with `execute`. `None` is no rate, also for an operation that has one. Nothing is paced: the rate sets the wait after a 429 and nothing else. A rate that is not a positive, finite number is refused with `Error::InvalidRequest`.

After a 5xx, a failed connection or a timeout, the client waits up to 1 second, then 1 to 2, then 3 to 4, and so on. So does a 429 of a call without a rate: an operation Amazon documents none for, and a `Request` sent with `execute`.

If the response has a `Retry-After` header, the client waits as long as it asks instead. A value that is neither seconds nor a date is ignored.

No wait has a ceiling. An operation limited to 1 request a minute waits 512 minutes before its tenth retry.

The timeout limits each attempt: asking a token source, the request and reading the body. The waits between attempts are not counted, so a call can take far longer than the timeout: 7 minutes for 3 retries at 1 request a minute, and 17 hours for 10. Choose `max_retries` by how long a call may take, or put the call in `tokio::time::timeout`. Dropping the future ends a wait as it ends a request.

When the retries run out, the call returns the last response, or `Error::Timeout` or `Error::Transport` if the last attempt got none.

Amazon limits each operation for each seller. The crate doesn't count your calls against those limits. Space them in your application.

## Pagination

An operation that returns its results in pages has a twin that ends in `_pages`. It takes the same parameters and returns a stream of pages. 82 operations have one.

```rust
use futures_util::StreamExt;
use peddler::apis::orders_v0;

let params = orders_v0::GetOrdersParams::new(vec!["A1F83G8C2ARO7P".into()]);
let mut pages = orders_v0::get_orders_pages(&client, params);
while let Some(page) = pages.next().await {
    let page = page?;
    println!("{} {} bytes", page.status, page.body.len());
}
```

The stream requests a page when it is polled, one at a time, and nothing when it is dropped. `pages.take(3)` stops after three pages. Each page is a raw `Response` and goes through the client like any call, so the token, the retries and the timeout apply to each.

The stream ends when a page carries no token for the next one. A page with an HTTP error status is yielded and ends it. A page that returns the token it was requested with, or a token that is not a string, is yielded and followed by a `PaginationError`.

For an operation without a twin, describe the paging yourself with a `Pagination`: the operation, where its token goes and where the next one comes from. Pointers into the arguments use the field names of the parameter struct.

```rust
use peddler::pagination::{Pagination, pages};

let mapping = Pagination::new("orders_v0.get_orders", "/next_token", "/payload/NextToken");
let arguments = serde_json::json!({ "marketplace_ids": ["A1F83G8C2ARO7P"] });
let mut stream = pages(&client, mapping, &arguments);
```

`peddler::apis::pagination::mapping` returns the `Pagination` of a generated twin.

## Documents

Reports, feeds and Data Kiosk queries exchange documents through signed URLs. `client.documents()` transfers them over the client's pool, without the access token.

```rust
use futures_util::StreamExt;
use peddler::documents::{Compression, TransferOptions};

let options = TransferOptions { compression: Compression::Gzip, ..TransferOptions::default() };
let download = client.documents().download("https://example.com/signed-report", options).await?;
println!("{:?}", download.charset());

let mut rows = download.into_tsv();
while let Some(row) = rows.next().await {
    let fields: Vec<String> = row?;
    println!("{}", fields.join(" | "));
}
```

A `Download` reads in one of these ways, each as it arrives:

| Method | Yields |
| --- | --- |
| `into_tsv()` | each row of a tab-separated document as a `Vec<String>`, decoded from the charset of the `Content-Type` to UTF-8 |
| `into_tsv_with_charset(charset)` | the same, decoded from the charset you name |
| `into_jsonl()` | each line of a JSON Lines document as a `serde_json::Value` |
| `into_jsonl_records()` | each line as a `String` of valid JSON, with its keys in their own order |
| `into_chunks()` | the bytes |
| `json(max_bytes)` | the whole document as a `serde_json::Value`, if it is no larger than `max_bytes` |
| `json_text(max_bytes)` | the whole document as a `String` of valid JSON |

`TransferOptions` holds the `timeout` of the whole transfer (30 seconds), `max_bytes` after decompression (no limit), `max_record_bytes` for a row (1 MiB) and `compression`. `Compression::Auto` decompresses when the reply says `Content-Encoding: gzip`. Use `Compression::Gzip` when the document's metadata says `GZIP`.

An upload takes a stream of `Bytes` and the content type.

```rust
use bytes::Bytes;
use futures_util::stream;
use peddler::documents::UploadOptions;

let source = stream::iter([Ok::<_, std::io::Error>(Bytes::from("<AmazonEnvelope/>"))]);
let options = UploadOptions { content_type: "text/xml; charset=UTF-8".into(), ..UploadOptions::default() };
let reply = client.documents().upload("https://example.com/signed-upload", source, options).await?;
println!("{}", reply.status);
```

Set `content_length` in `UploadOptions` when you know it. The body is then sent with that length, and a source that yields more or fewer bytes fails with `documents::Error::LengthMismatch`. Without it the body is sent chunked.

A transfer is never retried and never follows a redirect. A signed URL that answers outside 2xx is `documents::Error::Rejected`, which holds the status, the headers and up to 64 KiB of the body.

## Workflows

`client.workflows()` ties the Reports, Feeds and Data Kiosk operations to the transfers. It looks a document up by its ID with the client's token, then transfers it. One deadline covers both.

```rust
use futures_util::StreamExt;
use peddler::{documents::TransferOptions, workflows::WaitOptions};

let workflows = client.workflows();

let response = workflows.wait_for_report("report-id", WaitOptions::default()).await?;
let report = response.json()?;
if let Some(document_id) = report.report_document_id {
    let download = workflows.download_report_document(&document_id, TransferOptions::default()).await?;
    let mut rows = download.into_tsv();
    while let Some(row) = rows.next().await {
        println!("{:?}", row?);
    }
}
```

`wait_for_report`, `wait_for_feed` and `wait_for_query` poll every `interval` (5 seconds) until the job is `DONE`, `CANCELLED` or `FATAL`, and return that response, so check its processing status. They give up after `timeout` (300 seconds) with `WorkflowError::Timeout`. Nothing else is that error: one poll that takes longer than the client's timeout is `WorkflowError::Request(Error::Timeout)`. A poll is retried as the client's policy says, and a wait before a retry ends with the `timeout` of the whole wait.

`download_report_document`, `download_feed_document` and `download_query_document` take a document ID and return a `Download`. They decompress a document whose metadata says `GZIP`. The timeout of `TransferOptions` covers the lookup, with its retries and the waits before them, and the transfer. A lookup that runs past it, or past the client's timeout, is `WorkflowError::Request(Error::Timeout)`. A transfer that does is `WorkflowError::Document(documents::Error::Timeout)`, or `documents::Error::Timeout` from the stream once the download has started.

`create_and_upload_feed_document` creates a feed document, uploads your content to it and returns the feed document ID. It doesn't create the feed. Pass the ID to `create_feed`.

```rust
use bytes::Bytes;
use futures_util::stream;
use peddler::{apis::feeds_2021_06_30 as feeds, documents::UploadOptions};

let source = stream::iter([Ok::<_, std::io::Error>(Bytes::from("{\"header\":{},\"messages\":[]}"))]);
let document_id = client
    .workflows()
    .create_and_upload_feed_document("application/json; charset=UTF-8", source, UploadOptions::default())
    .await?;

let body = serde_json::json!({
    "feedType": "JSON_LISTINGS_FEED",
    "marketplaceIds": ["A1F83G8C2ARO7P"],
    "inputFeedDocumentId": document_id,
});
let feed = feeds::create_feed(&client, feeds::CreateFeedParams::new(body)).await?;
```

A workflow never retries a transfer. It creates a feed document as the client sends any write: retried after a 429 only, if the policy has retries. A metadata request that Amazon answers with an error is `WorkflowError::Http`, and `error.response()` returns the response. A failed upload is `WorkflowError::Upload`, which keeps the `document_id`, and holds `documents::Error::Timeout` when the upload ran out of time.

## Typed models

The responses of the operations are in each API module's `models`. Four more families cover the payloads Amazon sends outside the operations: `peddler::notifications`, `peddler::reports`, `peddler::feeds` and `peddler::data_kiosk`. All of them derive `serde::Deserialize`.

```rust
use peddler::notifications::order_change::Notification;

let message = r#"{"NotificationVersion":"1.0","NotificationType":"ORDER_CHANGE","PayloadVersion":"1.0",
    "EventTime":"2026-01-02T03:04:05Z","Payload":{"OrderChangeNotification":{"NotificationLevel":"OrderLevel",
    "SellerId":"A2SELLER","AmazonOrderId":"123-1234567-1234567","OrderChangeType":"OrderStatusChange",
    "OrderChangeTrigger":{"TimeOfOrderChange":"2026-01-02T03:04:00Z","ChangeReason":"Order Status Change"},
    "Summary":{"MarketplaceId":"A1F83G8C2ARO7P","OrderStatus":"Unshipped","PurchaseDate":"2026-01-02T03:00:00Z",
    "DestinationPostalCode":null,"FulfillmentType":"MFN","OrderType":"StandardOrder","OrderItems":[]}}},
    "NotificationMetadata":{"ApplicationId":"amzn1.sp.solution.1","SubscriptionId":"s1",
    "PublishTime":"2026-01-02T03:04:06Z","NotificationId":"n1"}}"#;
let notification: Notification = serde_json::from_str(message)?;
let order = &notification.payload.order_change_notification;
println!("{} is {}", order.amazon_order_id, order.summary.order_status);
```

Numbers are `serde_json::Number` with arbitrary precision, so a decimal amount keeps every digit.

## Errors

| Type | Is |
| --- | --- |
| `peddler::Error` | a call that got no response: `InvalidRequest`, `Timeout`, `Transport`, or `Authentication` when a token source failed |
| `api_error::ApiError` | a response outside 2xx, from `error_for_status` |
| `DecodeError` | a response that is not the status or the JSON a decoder expects |
| `auth::AuthError` | a token request that failed or that LWA rejected |
| `pagination::PaginationError` | a page stream that cannot continue |
| `documents::Error` | a transfer that failed, that the signed URL rejected, or a document that is not what the reader expects |
| `workflows::WorkflowError` | a wait or a document lookup that failed |

No error holds a token, a signed URL or the contents of a document, in its message or in `Debug`. `ApiError`, `documents::Rejection` and `WorkflowError::Http` hold the response Amazon sent.

The error enums, `documents::Compression` and `workflows::DocumentKind` are `#[non_exhaustive]`: a `match` on one needs a `_` arm, and a new variant is not a breaking change.

## Generated code

Everything under `src/apis`, `src/reports`, `src/feeds`, `src/notifications` and `src/data_kiosk` is generated from Amazon's models by [`peddler-codegen`][codegen], and committed. Building the crate needs no generator and no copy of Amazon's models.

```sh
cargo test -p peddler --locked
cargo clippy -p peddler --all-targets --locked -- -D warnings
```

The tests use recorded responses and loopback servers. They need no Amazon credentials.

[api-docs]: https://developer-docs.amazon.com/sp-api/docs/welcome
[gem]: https://github.com/lineofflight/peddler
[codegen]: https://github.com/lineofflight/peddler/tree/main/crates/peddler-codegen
