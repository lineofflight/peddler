# CLAUDE.md

You are working on Peddler, a Ruby library for interacting with Amazon's Selling Partner API (SP-API).

## Project Structure

```
peddler/
├── lib/
│   ├── peddler.rb              # Main entrypoint (GENERATED)
│   ├── peddler/
│   │   ├── api.rb              # Base API class (manual)
│   │   ├── endpoint.rb         # Endpoint configuration (manual)
│   │   ├── marketplace.rb      # Marketplace utilities (manual)
│   │   ├── token.rb            # LWA authentication (manual)
│   │   ├── error.rb            # Error classes (manual)
│   │   ├── response.rb         # Response wrapper (manual)
│   │   ├── apis/               # Generated API classes
│   │   ├── types/              # Generated type classes
│   │   └── helpers/            # Manual extensions for generated APIs
│   └── generator/              # Code generation system
│       ├── templates/          # ERB templates
│       └── rbs/                # RBS type generation
├── sig/                        # RBS signatures (generated + manual)
├── test/                       # Tests (mirrors lib/ structure)
└── selling-partner-api-models/ # Amazon's OpenAPI specs
```

### Architecture

Generated code (don't edit): `lib/peddler/{apis,types}/*`, `lib/peddler.rb`, `sig/peddler/{apis,types}/*`

Manual code (safe to edit): Core classes, generator, tests

### Core Concepts

- All API classes inherit from `Peddler::API`
- Response objects wrap HTTP.rb responses with helpers:
  - `.parse` - Parse JSON with type checking (uses Structure gem)
  - `.dig(*keys)` - Safely navigate nested hashes
  - `.to_h` - Get raw response hash
  - `.status` - HTTP status code
- Sandbox mode: `api.sandbox.method_name(...)`
- Rate limiting: Pass `retries:` to API constructor

## Commands

- Run test: `bundle exec ruby -Itest test/<path>_test.rb`
- Lint file: `bundle exec rubocop <path>.rb` (add `-A` to autocorrect)
- Type check: `bundle exec steep check <path>.rbs`
- Full suite: `bundle exec rake test`
- All linting: `bundle exec rake rubocop`
- All types: `bundle exec rake steep`
- Generate: `bundle exec rake generate`

Run the generator and type checker, which may take a few minutes or more, in the background.

## Tech Stack

- Ruby 3.2+
- [HTTP](https://github.com/httprb/http) - HTTP client
- [Structure](https://github.com/hakanensari/structure) - Type-safe response parsing
- Testing: Minitest with VCR (HTTP fixtures) and WebMock (stubbing)
- Types: RBS signatures checked with Steep
- Docs: YARD for public API documentation
- [Nokogiri](https://nokogiri.org) - Optional for S3 error parsing

## Code Style

- Wrap at 120 characters
- Positional args for required, keyword args for optional
- Follow patterns from neighboring files

## Development Practices

### Workflow

- Work on feature branches (delete when merged)
- Use descriptive names (e.g., `fix/api-timeout`)
- Use GitHub MCP, fall back to gh CLI
- TDD - write tests first
- Test behavior, not implementation
- VCR cassettes for integration tests
- Update CHANGELOG for user-facing changes (short, succinct one-liners)

### Testing

- Include `FeatureHelpers` for VCR setup and API instantiation
- Use `Marketplace.ids("UK")` for marketplace parameters
- Assert `res.status.success?` for API responses
- VCR cassettes auto-record and filter credentials
- See `test/peddler/apis/catalog_items_2022_04_01_test.rb` for patterns

## Code Generation

### Generator Workflow

1. Edit templates in `lib/generator/templates/` (operation.erb, type.erb, etc.)
2. Or modify logic in `lib/generator/` (operation.rb, type.rb, etc.)
3. Run `bundle exec rake generate` in background
4. Review generated files in `lib/peddler/apis/` and `lib/peddler/types/`
5. Run tests and type check

### Generator Internals

Main orchestrator: `lib/generator.rb`

Key modules: `api.rb`, `type.rb`, `operation.rb`, `templates/`

Pipeline: Clone specs → Generate APIs/types → Generate RBS → Format

To regenerate single API: `bundle exec rake generate[api_name]`

## SP-API Specifications

### Local Specs

- Location: `selling-partner-api-models/models/`
- If missing: `bin/generate-code` to download
- Search: Use `rg` (ripgrep)
- Parse: Use `jq`
- Authoritative source for API behavior

### Structure

Each OpenAPI spec contains `paths` (endpoints/operations), `definitions` (types), and `x-amzn-api-sandbox` (test data).

Use `jq` to parse, `rg` to search specs in `selling-partner-api-models/models/`

### External Research

Use the researcher subagent when OpenAPI specs don't contain needed information or when behavior differs from documented specs.

For quick local lookups, use jq/grep directly.
