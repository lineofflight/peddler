# AGENTS.md

Peddler is a Ruby library for Amazon's Selling Partner API (SP-API), using code generation from OpenAPI specs. Requests run on a Rust core (`crates/peddler`) that ships as a native extension (`crates/peddler-ruby`).

## Critical: Generated vs. Manual Code

Never edit generated code; changes will be overwritten:
- `lib/peddler/{apis,notifications,reports,feeds,data_kiosk}/`
- `lib/peddler.rb`, `lib/peddler/native/apis.rb`
- `sig/peddler.rbs`, `sig/peddler/native/apis.rbs`, `sig/peddler/{apis,notifications,reports,feeds,data_kiosk}/*`
- `crates/peddler/src/{apis,reports,feeds,notifications,data_kiosk}/`
- `crates/peddler-codegen/operation-inventory.json`

Safe to edit:
- Core: `lib/peddler/*.rb`, and `lib/peddler/native/*.rb` except `apis.rb`
- Rust core and extension: `crates/peddler/src/*.rs`, `crates/peddler-ruby/`
- Generators: `lib/generator/` (typed Ruby models), `crates/peddler-codegen/` (Rust code and the Ruby operation methods)
- Tests: `test/`, `test_native/`

## Commands

- Build: `bundle exec rake native:build` (the extension, into `tmp/native`; needs a Rust toolchain)
- Test: `bundle exec ruby -Itest -Itmp/native test/<path>_test.rb` (single file, after a build)
- Full check: `bundle exec rake` (whole suite + lint); `bundle exec rake test` for tests only. Both build the extension first
- Rust: `cargo test -p peddler --locked`, `cargo clippy -p peddler --all-targets --locked -- -D warnings`
- Lint: `bundle exec rubocop <path>.rb -A`
- Types: `bundle exec steep check`
- Generate: `bundle exec rake generate` (both generators); `bundle exec rake generate:verify` fails if generated files drift

Targeted generation: `rake generate:apis`, `generate:notifications`, `generate:reports`, `generate:feeds`, `generate:data_kiosk`, `generate:rust`

Run above in background, some commands may takes minutes.

## Key Concepts

- A single `Peddler::Client` reaches every API: `client.orders_v0.get_orders(...)`. The API methods and operations are generated into `lib/peddler/native/apis.rb`
- Types nested by API version (e.g., `Peddler::APIs::CatalogItems20220401::Item`)
- Consumer usage (auth, responses, errors, sandbox): see [README](README.md#usage)

## Generator Workflow

1. Edit templates in `lib/generator/templates/` or logic in `lib/generator/`; for operation methods and Rust code, edit `crates/peddler-codegen/`
2. Run `bundle exec rake generate` in background
3. Review generated files, run tests and type check

## Testing

- Include `FeatureHelpers` to replay a recorded cassette through a local server
- Use `Marketplace.ids("UK")` for marketplace params
- Assert `res.status.success?` for API responses
- Pattern: `test/peddler/apis/catalog_items_2022_04_01_test.rb`
- Tests of the native layer are in `test_native/` and use loopback servers

## Changelog Guidelines

When updating Amazon SP-API models or making core library changes, document the changes in `CHANGELOG.md` under the `## [Unreleased]` section following these rules:
1. **Core Gem Changes**: Document library changes (such as client initialization, retries, parsing, and general features) under the standard SemVer headers (`### Added`, `### Changed`, `### Removed`).
2. **SP-API Model Updates**: Group all auto-generated model updates (additions, modifications, and deprecations of Amazon specs) under a single `### Models` header. Use bullet points prefixed with `**Added**:`, `**Changed**:`, or `**Removed**:` to distinguish the type of update.

## SP-API Specs & Research

The [`amazon-sp-api` skill](skills/amazon-sp-api/SKILL.md) and [`building-with-peddler` skill](skills/building-with-peddler/SKILL.md) are the canonical sources for SP-API spec/issue research and Peddler usage. Keep that guidance there, not here, so the two can't drift.

Generator-only: `rake generate` manages a local checkout of `selling-partner-api-models/` (gitignored, pinned by `selling-partner-api-models.sha`, not shipped in the gem).
