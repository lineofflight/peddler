# Peddler Rust code generation

Generation-only crate, not a runtime dependency. Ordinary SDK builds use committed output and require neither this generator nor Node, Ruby or the Amazon spec checkout.

## Regenerate or check

From the repository root, install Rust stable, Ruby/Bundler and Node (CI uses Node 22):

```sh
bundle install
bundle exec rake generate:rust
bundle exec rake generate:rust:verify
```

Both tasks directly use `Generator::Specs.pinned_sha` and `sync(ref:)`, preserving `selling-partner-api-models.sha`. Setup may clone/fetch/switch the gitignored spec checkout; it installs the locked converter with `npm ci --prefix tools/openapi`. The CLI rejects dirty selected specs and a checkout differing from the pin before emitting files. Verify renders and compares without rewriting generated output. The legacy Ruby `generate` tasks are unchanged.

For separate setup and direct CLI use:

```sh
bundle exec rake generate:rust:setup
cargo test -p peddler-codegen --locked
cargo run -p peddler-codegen --locked -- --root .
cargo run -p peddler-codegen --locked -- --root . --check
```

Running generation twice produces the same 9 files: API root plus models, module, wire and metadata for each selected API. Do not edit committed output in `crates/peddler/src/apis` by hand. Models-only export requires a separate destination to protect integrated module declarations:

```sh
cargo run -p peddler-codegen --locked -- --root . --models-only --output-root tmp/model-export
cargo run -p peddler-codegen --locked -- --root . --models-only --output-root tmp/model-export --check
```

Existing destinations are canonicalized; equivalent root/symlink destinations are rejected. If a missing component prevents canonicalization, unresolved parent traversal is rejected. Use a separate destination without `..` or create it first.

## Toolchain and scope

Typify `=0.8.0` emits models after explicit normalization, including open string enums and optional-array presence. swagger2openapi `=7.0.8` is pinned by `tools/openapi/package-lock.json`; the Node wrapper delegates conversion. Progenitor `=0.15.0` emits private wire clients with external Typify model replacements and a dynamic Listings body. Generated metadata supplies CSV query names, defaults and success-model aliases to handwritten Rust/Ruby facades. `progenitor-client =0.15.0` is the runtime library.

Production selection is only Catalog Items `getCatalogItem` and Listings Items `patchListingsItem`, each with 1 referenced JSON success model. Unsupported selected parameter formats/shapes, collection formats, bodies and missing references fail generation. Broader corpus and multiple-success probes do not imply production support. Full facade generation and broader operations remain later work.

## Vendored raw-response patch

The workspace `[patch.crates-io]` selects `third_party/progenitor-impl`, copied from the published 0.15.0 package. Only `src/method.rs` differs in upstream source: [exact +3/-1 patch](../../third_party/raw-response.patch) selects existing ByteStream mode when `x-peddler-raw-response: true`. Declared response schemas and status codes remain intact. The runtime then collects success, declared errors and unexpected responses before optional typed decoding.

Source VCS metadata/package notices are preserved. The published package omitted LICENSE; the vendored MPL-2.0 license comes from upstream revision `76a3b70f0eb11e044b52ee15bd07bcc370c8adb5`, SHA256 `3f3d9e0024b1921b067d6f7f88deb4a60cbe7a78e76c64e3f1d7fc3b779b9d04`. See [vendor provenance](../../third_party/README.md).

Maintenance requires checking each upgrade against the published source, reviewing/reapplying the patch, regenerating and rerunning raw-response/path/query tests. This is a local build-time patch, with no remote fork or publication. Cargo patches do not propagate transitively to independently published consumers; release packaging remains unresolved. Node dependencies and the patched generator are absent from the ordinary SDK runtime graph.
