# Rust core and native Ruby preview

This is a local-development preview of Peddler's next major release. The shared Rust SDK will own transport, operations, auth and policy; Ruby will use a thin native binding. There will be no HTTP.rb adapter. Both Rust and Ruby APIs may change. The internal crate is version 0.1.0 with publishing disabled.

## Local development

Install Rust stable and Ruby 3.3, 3.4 or 4.0. From the repository root:

```sh
bundle install
bundle exec rake native:build native:test
bundle exec ruby -Ilib -Itmp/native -e 'require "peddler/native"'
```

The build copies the extension into `tmp/native` and respects `CARGO_TARGET_DIR`. Use `-Ilib -Itmp/native` for local scripts. Precompiled gems, release packaging and Windows support are later work. Load the preview with `require "peddler/native"` in a fresh process. It loads independently of the existing `peddler` entrypoint and HTTP.rb.

```ruby
require "peddler/native"

client = Peddler::Client.new(
  base_url: ENV.fetch("SP_API_BASE_URL", "https://sellingpartnerapi-eu.amazon.com"),
  access_token: ENV.fetch("SP_API_ACCESS_TOKEN"),
  timeout: 30,
)
response = client.request("GET", "/catalog/2022-04-01/items/188864544X",
  params: { marketplaceIds: "A1F83G8C2ARO7P" })
puts response.status
item = response.json
```

`params` accepts string/symbol keys and string, finite number or boolean values. Supply CSV values as strings; nil, arrays, nested hashes and duplicate names after normalization are rejected. `body` accepts nil, raw string bytes, or a hash/array serialized as JSON. Paths must start with `/`, with escaped segments and no query, fragment or alternate origin. Base URLs must be HTTP(S) origins without credentials, query, fragment or a non-root path.

Responses expose integer `status`, repeated header pairs in `headers`, and an ASCII-8BIT `body`. `json` parses lazily and caches the result. HTTP 4xx/5xx statuses remain responses. Transport failures raise `Peddler::Native::TransportError`; timeouts raise its `TimeoutError` subclass. Each native client uses 1 Tokio worker and a shared connection pool. Create clients after fork; inherited clients raise `Peddler::Native::ForkError`.

## Rust usage

Use a local path dependency: `peddler = { path = "/path/to/peddler/crates/peddler" }`. Run async requests inside a Tokio runtime with I/O and timers enabled. Client clones share a connection pool.

```rust
use peddler::{Client, Error, Request, Response};

async fn catalog_item(base_url: &str, token: &str) -> Result<Response, Error> {
    let client = Client::new(base_url, token)?;
    client.execute(Request {
        method: "GET".into(),
        path: "/catalog/2022-04-01/items/188864544X".into(),
        query: vec![("marketplaceIds".into(), "A1F83G8C2ARO7P".into())],
        body: None,
    }).await
}
```

The default timeout is 30 seconds; `Client::with_timeout` accepts a `Duration`. Responses contain `u16` status, header pairs and body bytes. Failures distinguish `Error::InvalidRequest`, `Error::Timeout` and `Error::Transport`, with sanitized messages.

## Current limits and checks

This milestone provides pooled HTTP transport and a native binding, not a complete SP-API SDK. Entire bodies are buffered. Only body bytes are byte-exact: repeated response header values survive, total wire order does not, and non-UTF8 header values decode lossily. There are no generated operations, token refresh, automatic retries, redirects, decompression or streaming yet. No performance claims have been measured.

Offline tests use shared sanitized Catalog GET, Listings PATCH and NotFound fixtures, plus loopback servers for encoding, errors, concurrency, timeout, interruption and fork behavior. No Amazon credentials or live calls are needed:

```sh
ruby tools/export_native_fixtures.rb --check
cargo test -p peddler --locked
cargo fmt --all --check
cargo clippy -p peddler --all-targets --locked -- -D warnings
bundle exec rake native:build native:test
bundle exec rake
```

Native CI tests the core without Ruby setup and the binding on Ruby 3.3, 3.4 and 4.0. The existing default Ruby checks remain useful during migration.

## Generator decision and roadmap

Use [Typify](https://github.com/oxidecomputer/typify) for Rust models and a small custom operation emitter. [Progenitor](https://github.com/oxidecomputer/progenitor) clients had incompatible CSV query encoding and response limitations. This choice is research, not integrated generation: probes at Amazon revision `3677bb9d96f4450e6843f1f8207005e925d5c867`, Typify 0.8.0 and Progenitor 0.15.0 compiled 70/70 API model sets after normalization and naming fixes, and 49/53 standalone schema sets. Progenitor generated 61/70 clients without proving wire compatibility.

1. **Transport foundation:** pooled Rust client, thin Ruby binding, shared offline fixtures and local build/CI. This preview covers this stage.
2. **Generated operations:** start with Catalog Items and Listings Items. Pin specs/tools and prove deterministic regeneration, GET CSV/path encoding, PATCH JSON/escaped SKU, unknown enum values and missing/empty/null presence against shared fixtures. Typify defaults to strict enums; adopt an explicit forward-compatible string-enum policy, using normalization that removes enum constraints if needed. Ruby forwarding methods must call the Rust operations so request semantics have 1 implementation.
3. **Auth, policy and documents:** scoped LWA/RDT caches, coalesced refresh, bounded retries, rate limits, process lifecycle, streaming transfers and bounded parsing.
4. **Major release:** migrate supported operations/helpers, replace the root Ruby entrypoint and dependencies, precompile gems for Ruby/platform targets, publish the Rust crate and document breaking changes. Benchmark before promising speedups.
