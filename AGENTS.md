# AGENTS.md

Peddler is a Ruby library for Amazon's Selling Partner API (SP-API), using code generation from OpenAPI specs. Requests run on a Rust core (`crates/peddler`) that ships as a native extension (`crates/peddler-ruby`).

## Critical: Generated vs. Manual Code

Never edit generated code; changes will be overwritten:
- `lib/peddler/{apis,notifications,reports,feeds,data_kiosk}/`
- `lib/peddler.rb`, `lib/peddler/native/apis.rb`
- `sig/peddler/{apis,notifications,reports,feeds,data_kiosk}/*`
- `sig/inline/` (`rake rbs:export` writes it from the inline RBS of the Ruby files)
- `crates/peddler/src/{apis,reports,feeds,notifications,data_kiosk}/`
- `crates/peddler-codegen/operation-inventory.json`

Safe to edit:
- Core: `lib/peddler/*.rb`, `lib/peddler/lwa/`, and `lib/peddler/native/*.rb` except `apis.rb`
- Hand-kept signatures: `sig/peddler/*.rbs`, `sig/peddler/native/*.rbs`
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
- Docs: `bundle exec rake rdoc` (the site, into `doc/`; `rake rerdoc` builds it again from nothing)
- Generate: `bundle exec rake generate` (both generators, then `rbs:export`); `bundle exec rake generate:verify` fails if generated files or `sig/inline` drift

Targeted generation: `rake generate:apis`, `generate:notifications`, `generate:reports`, `generate:feeds`, `generate:data_kiosk`, `generate:rust`

Run above in background, some commands may takes minutes.

## Key Concepts

- A single `Peddler::Client` reaches every API: `client.orders_v0.get_orders(...)`. The API methods and operations are generated into `lib/peddler/native/apis.rb`
- Types nested by API version (e.g., `Peddler::APIs::CatalogItems20220401::Item`)
- Consumer usage (auth, responses, errors, sandbox): see [README](README.md#usage)

## Inline RBS

Hand-written Ruby and the generated operation methods carry their types as inline RBS. Steep reads `lib/peddler.rb`, `lib/peddler/*.rb`, `lib/peddler/lwa/` and `lib/peddler/native/` inline (see `Steepfile`). `rake rbs:export` writes `sig/inline` from those files, for applications; it is committed and `rake rbs:verify` fails when stale. Never edit `sig/inline`.

A `.rbs` file under `sig/peddler/` holds only what inline RBS cannot say: members of `Data.define` and `Struct.new` classes, interfaces, type aliases, what the extension defines, delegated and dynamic methods. The typed models keep their generated `.rbs`. `lib/peddler/webmock.rb` is not checked: WebMock has no signatures.

- A leading annotation ends on the line directly above its `def`, `attr_*` or constant. A blank line detaches it.
- A trailing `#:` sits on the last line of the node.
- A comment line starts an annotation when it begins with `# @rbs` or `#:` (no space). Indented lines continue it.
- `# @rbs @name: Type` for instance variables only counts before the first statement of a class body, with a blank line after, or after its last statement.
- Doc style (`# @rbs name: Type -- text`) takes required and optional from the Ruby parameter. It cannot say overloads or type parameters. An unlisted parameter is `untyped`; a line naming no parameter is an error. The export keeps the text, as a list under the method's comment.
- A class may be declared in Ruby and in a `.rbs` file, if each member is declared once. An unannotated `def` in an inline file is `(?) -> untyped`, so every `def` takes an annotation and none is declared in a `.rbs` file as well.
- Annotation mistakes fail `steep check` and `# steep:ignore` does not silence them.
- Use `def self.x`, not `class << self`: Steep reads the latter as instance methods. RuboCop enforces it on these paths.
- Steep reads no alias: write a one-line `def` with its own `#:` line.
- Never run `steep check` on one file: it reports false unknown constants and skips the duplicate-declaration check. Check the whole project.
- `steep check --steepfile=Steepfile.shipped` checks `lib` against the signatures an application gets.

## Comments

Comments are Markdown, and RDoc builds the site from them with the signatures. No YARD tags.

- An example is a line "Example:", a blank comment line and a block indented by 4 spaces.
- An error is a sentence: "Raises Peddler::Error if ...".
- A class or a method is named as it is, and RDoc links it: `Peddler::Client#request`, `#sandbox`, `Client.new`. Don't start a line with `#name`: it breaks the paragraph.
- A link is `[text](url)`, or the URL alone in a paragraph of its own.
- `# :nodoc:` at the end of a `def` line, or of a constant's, hides it. On a line above, it hides the rest of the class too.
- The order is the description, the example, the `@rbs` lines, then what it raises. The site lists the parameters where the `@rbs` lines stand.

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
