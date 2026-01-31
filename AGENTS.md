# AGENTS.md

Peddler is a Ruby library for Amazon's Selling Partner API (SP-API), using code generation from OpenAPI specs.

## Critical: Generated vs. Manual Code

**Never edit generated code** - changes will be overwritten:
- `lib/peddler/apis/`, `notifications/`, `reports/`, `feeds/`
- `lib/peddler.rb`, `sig/peddler/{apis,notifications,reports,feeds}/*`

**Safe to edit:**
- Core: `lib/peddler/*.rb`
- Generator: `lib/generator/`
- Tests: `test/`

## Commands

- Test: `bundle exec ruby -Itest test/<path>_test.rb`
- Lint: `bundle exec rubocop <path>.rb -A`
- Types: `bundle exec steep check`
- Generate: `bundle exec rake generate` (runs in background, takes minutes)

Targeted generation: `rake generate:apis`, `generate:notifications`, `generate:reports`, `generate:feeds`, `generate:data_kiosk`

## Key Concepts

- APIs inherit from `Peddler::API`
- Response: `.parse` (typed), `.dig`, `.to_h`, `.status`
- Sandbox: `api.sandbox.method_name(...)`
- Types nested by API version (e.g., `Peddler::APIs::CatalogItems20220401::Item`)

## Generator Workflow

1. Edit templates in `lib/generator/templates/` or logic in `lib/generator/`
2. Run `bundle exec rake generate` in background
3. Review generated files, run tests and type check

## Testing

- Include `FeatureHelpers` for VCR setup
- Use `Marketplace.ids("UK")` for marketplace params
- Assert `res.status.success?` for API responses
- Pattern: `test/peddler/apis/catalog_items_2022_04_01_test.rb`

## SP-API Specs

Local specs: `selling-partner-api-models/models/` (use `jq` to parse, `rg` to search)

## External Resources

- [API Models](https://github.com/amzn/selling-partner-api-models) - OpenAPI specs and schemas
- [GitHub Issues](https://github.com/amzn/selling-partner-api-models/issues) - Troubleshooting, workarounds, Amazon responses
- [Official Documentation](https://developer-docs.amazon.com/sp-api/) - Use cases, guides, registration
