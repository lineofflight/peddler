# Rust core and native Ruby preview

Local-development preview of Peddler's next major release. The shared Rust SDK owns transport and 2 operations; Ruby calls the same Rust dispatcher through a thin native binding. Both APIs may change. Workspace crates are version 0.1.0 with publishing disabled.

## Implemented scope

- Catalog Items 2022-04-01: `getCatalogItem`.
- Listings Items 2021-08-01: `patchListingsItem`.

Each operation has 1 referenced success model. Typify generates the 74 models from these 2 API definition sets; Progenitor generates private wire clients. Thin ergonomic Rust and Ruby facades are handwritten. Other operations in those definitions are not exposed. Broader corpus probes are research evidence, not production coverage.

Ordinary core builds use committed output and need no generator, Node, Ruby or spec checkout:

```sh
cargo test -p peddler --locked
cargo clippy -p peddler --all-targets --locked -- -D warnings
```

## Rust usage

Use a local path dependency: `peddler = { path = "/path/to/peddler/crates/peddler" }`. Async calls require a Tokio runtime with I/O and timers enabled. Client clones share the existing connection pool; operation functions use that transport too.

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

Dynamic bodies retain unknown members, empty arrays and nulls by JSON meaning, rather than original whitespace or key order. Typed models accept unknown enum strings. Optional arrays distinguish `Some(vec![])` from `None`, but omitted and null both decode to `None`; raw JSON retains all states. Parameter constructors default `included_data` to `["summaries"]` or `["issues"]`; set it to `None` to omit the query. String parameters permit future enum values. Invalid path identifiers, CSV members and nonobject Listings bodies fail before network access.

`TypedResponse<T>::json()` decodes lazily. HTTP errors, unexpected statuses and malformed JSON remain raw responses; parsing can fail separately. `Client::execute(Request)` still supports raw requests. The default timeout is 30 seconds; `Client::with_timeout` accepts a `Duration`. Failures distinguish sanitized `Error::InvalidRequest`, `Error::Timeout` and `Error::Transport`.

## Native Ruby usage

Install Rust stable and Ruby 3.3, 3.4 or 4.0. From the repository root:

```sh
bundle install
bundle exec rake native:build native:test
bundle exec ruby -Ilib -Itmp/native -e 'require "peddler/native"'
```

The build copies the extension into `tmp/native` and respects `CARGO_TARGET_DIR`. Run local scripts with `bundle exec ruby -Ilib -Itmp/native script.rb`. Load the preview in a fresh process with its independent entrypoint:

```ruby
require "peddler/native"

client = Peddler::Client.new(
  base_url: ENV.fetch("SP_API_BASE_URL"),
  access_token: ENV.fetch("SP_API_ACCESS_TOKEN"),
  timeout: 30,
)
response = client.catalog_items_2022_04_01.get_catalog_item(
  asin: "188864544X", marketplace_ids: ["A1F83G8C2ARO7P"])
puts response.status
item = response.json if response.status == 200

response = client.listings_items_2021_08_01.patch_listings_item(
  seller_id: "seller", sku: "sku/1", marketplace_ids: ["A1F83G8C2ARO7P"],
  body: { productType: "PRODUCT", patches: [], futureField: nil })
puts response.body.bytesize
```

Set the 2 environment variables to your loopback server and dummy token for local testing. Ruby forwards argument envelopes to Rust, which owns validation and wire construction. `included_data` defaults match Rust; pass `nil` to omit it. Responses expose integer `status`, repeated header pairs and ASCII-8BIT `body`; `json` parses lazily and caches. HTTP 4xx/5xx remain responses. The raw `client.request(method, path, params: {}, body: nil)` interface remains available. Raw query values must be scalar strings, finite numbers or booleans; CSV values are strings there.

Transport failures raise `Peddler::Native::TransportError`; timeouts raise its `TimeoutError` subclass. Each native client uses 1 Tokio worker. Create clients after fork; inherited clients raise `Peddler::Native::ForkError`. Base URLs must be HTTP(S) origins without credentials, query, fragment or a non-root path. The preview entrypoint loads independently of HTTP.rb; there is no HTTP.rb compatibility adapter.

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

Entire response bodies are buffered and byte-exact. Duplicate header values survive, but total wire order is not retained and non-UTF8 values decode lossily. Token refresh, retries, rate limiting, pagination, streaming, full facade generation and broader API coverage remain work for later stages. Precompiled gems, release packaging, Windows support, root Ruby entrypoint migration and crate publication remain later work. The root Cargo patch does not propagate to independently published consumers; release packaging needs review. Benchmark before promising performance improvements.
