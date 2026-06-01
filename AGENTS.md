# AGENTS.md

Peddler is a Ruby library for Amazon's Selling Partner API (SP-API), using code generation from OpenAPI specs.

## Critical: Generated vs. Manual Code

Never edit generated code; changes will be overwritten:
- `lib/peddler/apis/`, `notifications/`, `reports/`, `feeds/`
- `lib/peddler.rb`, `sig/peddler/{apis,notifications,reports,feeds}/*`

Safe to edit:
- Core: `lib/peddler/*.rb`
- Generator: `lib/generator/`
- Tests: `test/`

## Commands

- Test: `bundle exec ruby -Itest test/<path>_test.rb` (single file)
- Full check: `bundle exec rake` (whole suite + lint); `bundle exec rake test` for tests only
- Lint: `bundle exec rubocop <path>.rb -A`
- Types: `bundle exec steep check`
- Generate: `bundle exec rake generate`

Targeted generation: `rake generate:apis`, `generate:notifications`, `generate:reports`, `generate:feeds`, `generate:data_kiosk`

Run above in background, some commands may takes minutes.

## Key Concepts

- APIs inherit from `Peddler::API`
- Types nested by API version (e.g., `Peddler::APIs::CatalogItems20220401::Item`)
- Consumer usage (auth, responses, errors, sandbox): see [README](README.md#usage)

## Generator Workflow

1. Edit templates in `lib/generator/templates/` or logic in `lib/generator/`
2. Run `bundle exec rake generate` in background
3. Review generated files, run tests and type check

## Testing

- Include `FeatureHelpers` for VCR setup
- Use `Marketplace.ids("UK")` for marketplace params
- Assert `res.status.success?` for API responses
- Pattern: `test/peddler/apis/catalog_items_2022_04_01_test.rb`

## SP-API Specs & Research

The [`sp-api-ruby` skill](skills/sp-api-ruby/SKILL.md) is the canonical source for SP-API spec/issue research. Keep that guidance there, not here, so the two can't drift.

Generator-only: `rake generate` manages a local checkout of `selling-partner-api-models/` (gitignored, pinned by `selling-partner-api-models.sha`, not shipped in the gem).
