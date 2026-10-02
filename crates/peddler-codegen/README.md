# Peddler Rust code generation

Generation-only crate, not a runtime dependency. Ordinary SDK builds use committed output and require neither this generator nor Node, Ruby or the Amazon spec checkout.

## Regenerate or check

From the repository root, install Rust stable, Ruby/Bundler and Node (CI uses Node 22):

```sh
bundle install
bundle exec rake generate:rust
bundle exec rake generate:rust:verify
```

Both tasks directly use `Generator::Specs.pinned_sha` and `sync(ref:)`, preserving `selling-partner-api-models.sha`. Setup may clone/fetch/switch the gitignored spec checkout; it installs the locked converter with `npm ci --prefix tools/openapi`. The CLI rejects dirty API specs, missing or extra pinned API sources and a checkout differing from the pin before emitting files. Verify renders and compares without rewriting generated output. The legacy Ruby `generate` tasks are unchanged.

For separate setup and direct CLI use:

```sh
bundle exec rake generate:rust:setup
cargo test -p peddler-codegen --locked
cargo run -p peddler-codegen --locked -- --root .
cargo run -p peddler-codegen --locked -- --root . --check
```

Running generation twice produces the same 355 files: 70 model/module/wire/metadata/facade sets, the API root and dispatcher, Ruby facades/signatures and the operation inventory. `manifest::ALL_APIS` explicitly records the pinned source path, Rust module, Ruby family/version and latest membership for 58 families. The CLI validates that inventory against tracked API JSON files at the pin. Do not edit committed output in `crates/peddler/src/apis` by hand. Models-only export requires a separate destination to protect integrated module declarations:

```sh
cargo run -p peddler-codegen --locked -- --root . --models-only --output-root tmp/model-export
cargo run -p peddler-codegen --locked -- --root . --models-only --output-root tmp/model-export --check
```

Existing destinations are canonicalized; equivalent root/symlink destinations are rejected. If a missing component prevents canonicalization, unresolved parent traversal is rejected. Use a separate destination without `..` or create it first.

## Toolchain and scope

Typify `=0.8.0` emits all 2620 named API models. swagger2openapi `=7.0.8` converts copied input; Progenitor `=0.15.0` owns wire builders, URLs, queries, headers and request-body serialization. `progenitor-client =0.15.0` is the runtime library. All 70 clients and 384 facades compile in the SDK. Per-operation schema metadata generates parameter types/defaults/validation, CSV hook names, Rust dispatch, 70 Ruby keyword facades and 58 aliases with RBS signatures.

Every facade validates and serializes its body before the shared `Client::run` authorization/policy runner. Each attempt creates a fresh generated builder against the ready client snapshot. The wire pre hook validates origin, canonicalizes paths, groups only the operation's CSV fields and supplies auth/timeout headers; exec calls shared HTTP execution directly inside the runner. A small `WireContext` restores explicitly allowed empty query arrays and removes the synthetic body/framing headers for omitted optional bodies, addressing Progenitor0.15's treatment of these omissions without another vendor patch.

Every response stays raw until optional typed decoding. A single success shape uses `TypedResponse<T>`; empty/schemaless successes use `Response`; distinct success shapes use status-specific `json_200`/`json_202` conveniences. Dynamic generic bodies preserve unknown nested fields and arbitrary JSON numbers. Schema parameter defaults remain separate from removed model defaults. Date/date-time parameters use validated strings so their supplied representation survives on the wire; booleans, integers and numbers have concrete scalar types.

Copied schema repairs are narrow: invalid scalar collectionFormat annotations are removed; CatalogItems20201201's 2 scalar `summaries` defaults become their declared array form; ShippingV2's duplicate linkCarrierAccount PUT ID gains `_put`, preserving POST's established method name. Other invalid defaults and unsupported shapes fail before writing. Original IDs/methods/paths remain in the committed inventory. `--check` checks every output and rejects obsolete generated API Rust files. Checkout HEAD/pin and every consumed tracked API source must be clean; the full API file manifest must equal the pin.

Model numbers use `serde_json::Number` with arbitrary precision and retain named wrappers. Schemars represents numeric schema bounds as f64 internally; normalization preserves constraints while canonicalizing their spelling. Open string enums, optional array presence and removed model defaults remain. Pagination and supplemental schemas belong to subsequent tasks.

Converter regressions run with `node --test tools/openapi/convert.test.cjs`. Codegen tests include actual generated-model precision roundtrips; `cargo check -p peddler --locked` compiles every API model namespace.

## Vendored raw-response patch

The workspace `[patch.crates-io]` selects `third_party/progenitor-impl`, copied from the published 0.15.0 package. Only `src/method.rs` differs in upstream source: [exact +3/-1 patch](../../third_party/raw-response.patch) selects existing ByteStream mode when `x-peddler-raw-response: true`. Declared response schemas and status codes remain intact. The runtime then collects success, declared errors and unexpected responses before optional typed decoding.

Source VCS metadata/package notices are preserved. The published package omitted LICENSE; the vendored MPL-2.0 license comes from upstream revision `76a3b70f0eb11e044b52ee15bd07bcc370c8adb5`, SHA256 `3f3d9e0024b1921b067d6f7f88deb4a60cbe7a78e76c64e3f1d7fc3b779b9d04`. See [vendor provenance](../../third_party/README.md).

Maintenance requires checking each upgrade against the published source, reviewing/reapplying the patch, regenerating and rerunning raw-response/path/query tests. This is a local build-time patch, with no remote fork or publication. Cargo patches do not propagate transitively to independently published consumers; release packaging remains unresolved. Node dependencies and the patched generator are absent from the ordinary SDK runtime graph.
