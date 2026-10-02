# Rust SDK and native Ruby APIs

Peddler's next major release implementation. The shared Rust SDK owns transport, authentication, request policy and all 384 operations across 70 API versions; Ruby calls the same Rust dispatcher through a thin native binding. Workspace crates are version 0.1.0 with publishing disabled.

## Implemented scope

All 70 namespaces and 2620 named API definitions at the repository pin are generated. Every operation has a concrete `*Params` struct and a public async function. Rust dispatch accepts `api_version.snake_case_operation`; Ruby exposes real keyword methods on 70 `Peddler::Native` classes, with version accessors and 58 latest-family aliases on `Peddler::Client`.

The committed [operation inventory](../peddler-codegen/operation-inventory.json) records every source, key, method, path, parameter and success status. Shipping V2's duplicate upstream ID keeps POST as `link_carrier_account` and exposes PUT as `link_carrier_account_put`.

Ordinary core builds use committed output and need no generator, Node, Ruby or spec checkout:

```sh
cargo test -p peddler --locked
cargo clippy -p peddler --all-targets --locked -- -D warnings
```

## Rust usage

Use a local path dependency: `peddler = { path = "/path/to/peddler/crates/peddler" }`. Async calls require a Tokio runtime with I/O and timers enabled. Client clones and restricted views share the connection pool, token caches and rate buckets. Operation functions and raw requests use the same authentication and policy runner.

```rust
use peddler::{Client, apis::{catalog_items_2022_04_01 as catalog,
    listings_items_2021_08_01 as listings}};

async fn example(base_url: &str, token: &str) -> Result<(), Box<dyn std::error::Error>> {
    let client = Client::new(base_url, token)?;
    let response = catalog::get_catalog_item(&client,
        catalog::GetCatalogItemParams::new("188864544X".into(),
            vec!["A1F83G8C2ARO7P".into()])).await?;
    println!("{}", response.raw.status);
    if response.raw.status == 200 {
        let item: catalog::models::Item = response.json()?;
        println!("{}", item.asin);
    }

    let body = serde_json::json!({"productType": "PRODUCT", "patches": [],
        "futureField": null});
    let response = listings::patch_listings_item(&client,
        listings::PatchListingsItemParams::new("seller".into(), "sku/1".into(),
            vec!["A1F83G8C2ARO7P".into()], body)).await?;
    let raw = response.into_raw();
    println!("{} {}", raw.status, raw.body.len());
    Ok(())
}
```

Listings accepts any serializable object body, including `serde_json::Value` or a typed model:

```rust
let body = listings::models::ListingsItemPatchRequest {
    product_type: "PRODUCT".into(),
    patches: vec![],
};
let params = listings::PatchListingsItemParams::new(
    "seller".into(), "sku/1".into(), vec!["A1F83G8C2ARO7P".into()], body);
let response = listings::patch_listings_item(&client, params).await?;
```

Dynamic bodies retain unknown members, empty arrays and nulls by JSON meaning, rather than original whitespace or key order. Typed models accept unknown enum strings. Optional arrays distinguish `Some(vec![])` from `None`, but omitted and null both decode to `None`; raw JSON retains all states. Parameter constructors retain schema defaults, including `included_data` as `["summaries"]` or `["issues"]`; set it to `None` to omit the query. String parameters permit future enum values. Invalid path identifiers, scalar formats/patterns/bounds, headers, CSV members and wrong body shapes fail before acquiring authorization. Required arrays require values unless the schema explicitly permits 0 items; optional arrays honor `minItems`. Explicit allowed empty query arrays emit an empty value, while `None` omits them. Repeated `mskus` arrays retain each value and allow commas. Body facades accept serializable objects or arrays according to the declared top-level shape; nested fields stay flexible.

`TypedResponse<T>::json()` decodes lazily. HTTP errors, unexpected statuses and malformed JSON remain raw responses; parsing can fail separately. `Client::execute(Request)` still supports raw requests. The default timeout is 30 seconds; `Client::with_timeout` accepts a `Duration`. The total deadline includes rate waits, token refresh, retries and response-body collection. Failures distinguish sanitized `Error::InvalidRequest`, `Error::Timeout`, `Error::Transport` and `Error::Authentication(AuthError)`. Authentication errors retain only classification and rejected status, never server bodies.

Operations with only empty or schemaless successes return `Response`. Multiple success shapes expose status-specific lazy decoders that check the status before parsing:

```rust
use peddler::apis::fulfillment_outbound_2026_07_04 as outbound;
let response = outbound::create_order(&client,
    outbound::CreateOrderParams::new(serde_json::json!({"lineItems": []}))).await?;
match response.raw.status {
    200 => { let order = response.json_200()?; },
    202 => { let accepted = response.json_202()?; },
    _ => { response.raw.error_for_status()?; },
}
```

No execution path eagerly parses response JSON. Empty-parameter operations use `Params::new()`; optional bodies default to absence. The dispatcher selects a function pointer, then constructs a boxed handler in a separate operation function to bound native-thread stack use. Direct typed calls remain unboxed.

## Authentication and policy

`Client::new` and `with_timeout` accept a static token. Use `Client::with_config(ClientConfig)` for refresh-token or grantless LWA authentication:

```rust
use peddler::{Client, ClientConfig, auth::Credentials};
let mut config = ClientConfig::new("https://sellingpartnerapi-eu.amazon.com",
    Credentials::RefreshToken {
        client_id: "application-id".into(),
        client_secret: "application-secret".into(),
        refresh_token: "seller-refresh-token".into(),
    });
config.policy.retry.max_retries = 2;
let client = Client::with_config(config)?;
```

Construction validates configuration without HTTP. The default LWA endpoint is
`https://api.amazon.com/auth/o2/token`; `lwa_endpoint` supports a loopback test
server. HTTPS and explicit HTTP loopback origins are accepted. LWA refresh-token
and client-credentials grants coalesce concurrent refreshes, cache tokens and
refresh before expiry. Dropping the last refresh waiter releases abandoned HTTP
work; other waiters can continue their shared refresh.

`client.restricted(RestrictedScope)` returns an immutable view using RDT. Scope
validation is local; matching canonical scopes reuse their cached token, changed
resources or target applications use separate entries. RDT bootstrap uses the
base LWA/static token. Views share authentication, pool and request policy.

Policy is disabled by default. `PolicyConfig` accepts fully qualified operation
keys, such as `catalog_items_2022_04_01.get_catalog_item`, with `RateLimit` rate
and burst. Raw requests use `raw`; `execute_with_operation(key, request)` selects
another bucket. Observed Amazon rates update configured buckets. Retries apply
only to GET/HEAD/OPTIONS on 429/500/502/503/504, with bounded jitter and
Retry-After. PATCH, 401/403, transport and authentication failures never retry.
A backoff exceeding the remaining deadline returns the last raw response.

`response.error_for_status()` opts into Rust API-error classification and keeps
status, duplicate headers and body bytes. It extracts optional code/request ID
without exposing server bodies in error formatting.

Use `auth::LwaClient` in Rust or `Peddler::Native::LWA` in Ruby to exchange an
authorization code for tokens:

```rust
use peddler::auth::LwaClient;

let lwa = LwaClient::new("client-id", "client-secret")?;
let tokens = lwa.exchange_authorization_code("code", Some("https://app.example/callback")).await?;
println!("{}", tokens.refresh_token);
```

```ruby
require "peddler/native"

lwa = Peddler::Native::LWA.new(client_id: "client-id", client_secret: "client-secret")
tokens = lwa.exchange_authorization_code(code: "code", redirect_uri: "https://app.example/callback")
puts tokens.refresh_token
```

Omit `redirect_uri` only for SDK-originated grants; otherwise provide the exact URI used during authorization. Consent, state handling and token storage stay with the application.

## Native Ruby usage

Install Rust stable and Ruby 3.3, 3.4 or 4.0. From the repository root:

```sh
bundle install
bundle exec rake native:build native:test
bundle exec ruby -Ilib -Itmp/native -e 'require "peddler/native"'
```

The build copies the extension into `tmp/native` and respects `CARGO_TARGET_DIR`. Run local scripts with `bundle exec ruby -Ilib -Itmp/native script.rb`. Load the native APIs in a fresh process with its independent entrypoint:

```ruby
require "peddler/native"

client = Peddler::Client.new(
  base_url: ENV.fetch("SP_API_BASE_URL"),
  access_token: ENV.fetch("SP_API_ACCESS_TOKEN"),
  timeout: 30,
)
response = client.catalog_items.get_catalog_item(
  asin: "188864544X", marketplace_ids: ["A1F83G8C2ARO7P"])
puts response.status
item = response.json if response.status == 200

response = client.listings_items_2021_08_01.patch_listings_item(
  seller_id: "seller", sku: "sku/1", marketplace_ids: ["A1F83G8C2ARO7P"],
  body: { productType: "PRODUCT", patches: [], futureField: nil })
puts response.body.bytesize
```

Set the 2 environment variables to your loopback server and dummy token for local testing. Ruby forwards argument envelopes to Rust, which owns validation and wire construction. `included_data` defaults match Rust; pass `nil` to omit it. Responses expose integer `status`, repeated header pairs and ASCII-8BIT `body`; `json` parses lazily and caches. HTTP 4xx/5xx remain responses. The raw `client.request(method, path, params: {}, body: nil)` interface remains available. Raw query values must be scalar strings, finite numbers or booleans; CSV values are strings there.

Use `client_id:`, `client_secret:` and exactly one of `refresh_token:` or `scope:`
in place of `access_token:` for LWA authentication. Set `retries:`, `retry_delay:`
and `max_retry_delay:` to opt into safe retries. `rate_limits:` maps operation
keys to `{ rate: Float, burst: Integer }`. For example:

```ruby
client = Peddler::Client.new(base_url: ENV.fetch("SP_API_BASE_URL"),
  client_id: ENV.fetch("LWA_CLIENT_ID"), client_secret: ENV.fetch("LWA_CLIENT_SECRET"),
  refresh_token: ENV.fetch("SP_API_REFRESH_TOKEN"), retries: 2,
  rate_limits: { "catalog_items_2022_04_01.get_catalog_item" => { rate: 2.0, burst: 2 } })
restricted = client.restricted(resources: [{ method: "GET", path: "/orders/v0/orders/{orderId}/address" }])
response = restricted.request("GET", "/orders/v0/orders/example/address")
response.raise_for_status! # Returns self on 2xx, otherwise raises Native::APIError.
```

`Native::APIError` exposes `response`, `kind`, optional `code` and `request_id`.
HTTP errors remain ordinary responses until `raise_for_status!` is called. Rust
computes this metadata outside the GVL. Raw `request` accepts `operation:` to
route a configured bucket, defaulting to `raw`.

Transport failures raise `Peddler::Native::TransportError`; timeouts raise its
`TimeoutError` subclass. Authentication failures raise
`Peddler::Native::AuthenticationError`, with optional rejected `status` and a
sanitized message. Each native client owns 1 Tokio worker shared with restricted
views. Create clients after fork; inherited clients raise `Peddler::Native::ForkError`. Base URLs must be HTTP(S) origins without credentials, query, fragment or a non-root path. The native entrypoint loads independently of HTTP.rb; there is no HTTP.rb compatibility adapter.

## Pagination

Pagination is explicit. [`pagination.json`](../peddler-codegen/pagination.json) maps 79 operations to the argument that carries the token and the response field that returns the next one, and lists 12 candidate operations it excludes, each with a reason. Generation resolves every operation, argument and response path against the pinned specs, and fails if an operation with a continuation-like field is neither mapped nor excluded. Nothing is inferred from names at runtime.

Rust streams raw pages lazily. Each page runs through the normal operation runner, so authorization, rate limits, retries and the timeout apply per page. Pages are fetched one at a time and nothing runs in the background; dropping the stream stops fetching.

```rust
use futures_util::StreamExt;
use peddler::apis::orders_v0::{GetOrdersParams, get_orders_pages};

let params = GetOrdersParams::new(vec!["ATVPDKIKX0DER".into()]);
let mut pages = get_orders_pages(&client, params, None); // max_pages: None is unbounded
while let Some(page) = pages.next().await {
    let page = page?; // Result<Response, PaginationError>
    println!("{}", page.status);
}
```

`max_pages` caps requests; `Some(0)` makes none. An absent, null or empty response token ends the stream. An HTTP error page is yielded once and ends it without decoding. A repeated token (including the one you started with), a non-string token or a malformed 2xx body yields the page and then one `PaginationError`. Errors never include tokens, bodies or arguments. Caller arguments are serialized once and never mutated.

Continuations keep every argument and replace only the token, except where the pinned docs say otherwise:

- `get_feeds`, `get_reports` and the 3 A+ Content search and relation operations take the token as the only parameter. Their continuations send the token (and A+ path arguments) alone, which also avoids re-sending defaults and required filters. A+ uses a private generated adapter operation under the original operation key, so policy is unchanged.
- Inbound V0 `get_shipments` and `get_shipment_items` continue with `query_type: "NEXT_TOKEN"` and drop their date and shipment filters.
- `support_2025_02_01.list_cases` carries the token in the POST body (`/body/nextToken`) and follows empty pages.

Excluded candidates include Data Kiosk `get_query` (its token starts another query), Promotions `get_promotion` (4 nested selection tokens), Replenishment `list_offers` and `list_offer_metrics` (numeric offsets), Inbound V0 `get_labels` (numeric start index), and the non-pagination Shipping `requestToken`, FBA idempotency header and restricted data token. Inbound V0 `get_shipment_items_by_shipment_id` returns a `NextToken`, but the pinned docs do not say where to send it, so opt in explicitly:

```rust
use peddler::pagination::{Continuation, Pagination, pages};

let mapping = Pagination {
    operation: "fulfillment_inbound_v0.get_shipment_items_by_shipment_id".into(),
    input: "/next_token".into(),
    output: "/payload/NextToken".into(),
    continuation: Continuation {
        operation: Some("fulfillment_inbound_v0.get_shipment_items".into()),
        keep: Some(vec!["marketplace_id".into()]),
        set: vec![("query_type".into(), "NEXT_TOKEN".into())],
        ..Continuation::default()
    },
};
let stream = pages(&client, mapping, &serde_json::json!({"shipment_id": "FBA1", "marketplace_id": "ATVPDKIKX0DER"}), None);
```

Pointers use native snake_case argument keys; body keys keep the schema's spelling. `Continuation` can change the operation, `keep` only listed top-level arguments, `drop` some and `set` others.

Ruby returns a rewindable `Enumerator` of `Peddler::Native::Response` from each generated `*_pages` method, which accepts the operation's keywords plus `max_pages:`. Each `each` starts over from the first page. Pages come from the same Engine operation runner, so `break`, `first` and abandoning an external enumerator never fetch another page. A pagination failure raises `Peddler::Native::PaginationError` (`reason` is `:malformed_response`, `:invalid_token` or `:repeated_token`) after the last good page.

```ruby
client.orders_v0.get_orders_pages(marketplace_ids: ["ATVPDKIKX0DER"]).each do |page|
  page.raise_for_status!
  puts page.json.dig("payload", "Orders").size
end

mapping = Peddler::Native::Pagination.new(operation: "...", input: "/next_token", output: "/payload/NextToken")
client.pages(mapping, { shipment_id: "FBA1" }, max_pages: 3)
```

The shared loopback cases in `test/fixtures/native/pagination/cases.json` replay through both the Rust stream and the Ruby enumerator.

## Generation decision

Use Typify `=0.8.0` for models and Progenitor `=0.15.0` for wire clients, with swagger2openapi `=7.0.8` converting Swagger. A shared pre-hook applies CSV query grouping, canonical path escaping, origin checks, auth and timeout policy. Generated clients reuse the runtime's reqwest handle. See [generator instructions](../peddler-codegen/README.md) for pins, deterministic checks and the exact vendored raw-response patch.

The patch is generation-only: it selects Progenitor's existing ByteStream response mode via `x-peddler-raw-response`, retaining declared schemas/statuses. This preserves raw HTTP responses before optional typed decoding. Upgrades must reapply and review the patch and rerun wire/response tests. Committed SDK code uses the unpatched published `progenitor-client` runtime.

## Checks and remaining work

Offline tests use sanitized fixtures and loopback servers for encoding, typed/dynamic bodies, errors, concurrency, timeout, interruption and fork behavior. No Amazon credentials or live calls are needed:

```sh
ruby tools/export_native_fixtures.rb --check
cargo fmt --all --check
bundle exec rake native:build native:test
bundle exec rake
bundle exec rake generate:rust:verify
```

CI configures Ubuntu core checks without Ruby setup, a separate generation job with Ruby/Node/spec setup, and native Ruby 3.3/3.4/4.0 jobs. Configured jobs are not evidence of completed remote runs.

Entire response bodies are buffered and byte-exact. Duplicate header values survive, but total wire order is not retained and non-UTF8 values decode lossily. Precompiled gems, release packaging, Windows support, root Ruby entrypoint migration and crate publication remain later work. The root Cargo patch does not propagate to independently published consumers; release packaging needs review. Benchmark before promising performance improvements.

## Native signed document transfers

Signed URL transfers share the Client HTTP pool and Tokio runtime, with no API
credentials, redirects or retries. Reports/Feeds/Data Kiosk document ID and
lifecycle conveniences are separate follow-up work.

```ruby
require "peddler/native"
client.download_document(signed_url, compression: :gzip) do |document|
  puts document.status
  document.each_tsv(consistent_fields: true) { |fields| save_row(fields) }
end
client.download_document(signed_url).each_jsonl { |row| save_row(row) }
File.open("feed.xml", "rb") do |io|
  reply = client.upload_document(signed_url, io,
    content_type: "text/xml; charset=UTF-8", content_length: io.size,
    headers: { "x-required-signed-header" => "value" })
  reply.raise_for_status! # HTTP errors are opt-in, as for API responses.
end
```

`download_document` returns `Native::Document`; its optional block ensures close
on any exit. `each_chunk`, `each_jsonl`, and `each_tsv(consistent_fields: false)`
return Enumerators without a block. Iteration closes on exhaustion, break and
exceptions. `close` is idempotent; `closed?` reports closure. Choose one consumption
mode per document. Concurrent reads and mode changes raise `DocumentError`.
`json(max_bytes:)` is explicitly buffered and requires a positive byte bound.
Native chunk strings and error bodies use binary encoding; TSV fields are UTF-8
strings. JSONL null rows yield nil without ending iteration. JSON integers retain
arbitrary precision; decimal numbers become BigDecimal, including nested values.
Decimal exponent overflow/underflow raises a sanitized DocumentError instead of
silently becoming Infinity or zero.
Ruby JSON decoding only materializes Rust-validated rows or bounded whole JSON.
Ruby allocates chunk strings and row objects. Keep or discard emitted rows
according to your own memory budget.

Transfer keywords match Rust: `timeout` in seconds (30 by default),
`compression: :auto/:none/:gzip`, `max_bytes` (1 GiB decoded), `max_record_bytes`
(1 MiB), `max_records` (u64 maximum), and `max_response_bytes` (64 KiB). Limits must
be positive integers. `:gzip` supports Amazon metadata with or without the same
Content-Encoding header; `:auto` follows that header, and `:none` leaves bytes raw.
Rust enforces decompression, record and row bounds plus the original absolute
transfer deadline. CPU parsing detects expiry after completing work. Unknown or
invalid settings raise sanitized ArgumentError. Document metadata exposes `status`,
repeated `headers`, `error_body` and `error_body_truncated?`; non-2xx body bytes are
bounded and raw. Structured readers reject non-2xx status; chunks can expose its
retained raw body. Signed URLs are omitted from inspect and exception messages.

Uploads accept binary String or an object implementing `read(length)` returning
String or nil. IO reads execute on the calling Ruby thread with the GVL, in at
most 64 KiB chunks. A capacity-1 native channel passes owned bytes to the shared
runtime; it preserves backpressure without collecting the source. The HTTP stack
and its socket buffers have additional bounded overhead. No fileno is required.
`content_type:` is passed exactly; optional `headers: {}` supplies signed headers,
while Rust rejects framing/auth/origin overrides. `content_length:` is optional
and verifies actual bytes, with EOF lookahead when the declared length is reached.
Early non-2xx rejection preserves the raw response and stops feeding the source.
Uploads never retry. The reply is `Native::Response`, with repeated headers,
bounded binary body and `body_truncated?`; `raise_for_status!` uses Rust metadata.

Format, compression, byte/record/row limit and length failures raise
`Native::DocumentError`. A source failure raises `Native::DocumentError` with
the source's exception as its cause. Deadline expiry raises its subclass
`Native::DocumentTimeoutError`. Thread interruption cancels work, drops active
sockets and lets the same client start another transfer. Closing a document
cancels an active read. A stream remains valid after parent Client GC; every
native handle rejects inherited state with ForkError after fork, so construct a
new Client in the child. A Ruby source read that blocks must return or be
interrupted before the calling Ruby method can return, while the background
transfer deadline still cancels HTTP work.

A local memory probe generates and consumes bytes incrementally, retaining no
whole fixture or emitted rows:

```sh
bundle exec ruby -Ilib -Itmp/native tools/native_document_memory_probe.rb 128 gzip
/usr/bin/time -l bundle exec ruby -Ilib -Itmp/native tools/native_document_memory_probe.rb 512 gzip
```
