# CLAUDE.md

You are working on Peddler, a Ruby library that allows sellers and vendors to interact with Amazon's Selling Partner API (SP-API).

## Communication Style

- Avoid unnecessary validations like "you're (absolutely) right"
- Focus on the task at hand without commentary on correctness

## Commands

### General Development

- Run a test: `bundle exec ruby -Itest test/path/to/test_file.rb`
- Run all tests: `bundle exec rake test`
- Lint a file: `bundle exec rubocop path/to/file.rb`
- Lint all files: `bundle exec rake rubocop`
- Add `-A` for rubocop to autocorrect
- Type check a path: `bundle exec steep check path/to/file.rbs`
- Type check: `bundle exec rake steep`
- Generate API classes from OpenAPI specs: `bin/generate-code`
- **Note** Type checking and generating code takes up to a few minutes. Run in the background and check periodically back. You may continue working on something else in the meantime.
- When encountering errors or ambiguity, ask rather than assume

## Tech Stack

- Ruby 3.2+
- [HTTP](https://github.com/httprb/http)
- [Minitest](https://github.com/minitest/minitest)
- [VCR/WebMock](https://github.com/vcr/vcr)
- [YARD](https://rubydoc.info/gems/yard/file/docs/Tags.md)
- [RuboCop](https://docs.rubocop.org)
- [RBS](https://github.com/ruby/rbs)
- [Steep](https://github.com/soutaro/steep)

## Code Style and Architecture Guidelines

### Ruby

- Keep your code idiomatic and direct
- Write clear, direct code over clever code
- Avoid excessive commenting - let the code speak for itself
- Design intuitive APIs for your classes and modules
- Hide internal details behind private methods
- Use concise and descriptive names
- Wrap code and comments at 120 characters
- Use positional and keyword arguments for required and optional parameters, respectively
- Follow patterns and conventions from neighboring files

### API Design

- Follow Amazon SP-API conventions and naming patterns
- Maintain consistent method signatures across API classes
- Support both sandbox and production environments

### Code Generation System

- **API classes and types are auto-generated** from Amazon's OpenAPI specs
- Generated code lives in `lib/peddler/apis/`, `lib/peddler/types/`, and `lib/peddler.rb`
- **Never manually edit generated files** - changes will be overwritten on next generation
- The generator in `lib/generator/` transforms OpenAPI specs into Ruby classes
- OpenAPI models are downloaded to `selling-partner-api-models/` from Amazon's official repository
- To change generated API classes, edit generator logic in `lib/generator/` or templates in `lib/generator/templates/`
- Run `bin/generate-code` to regenerate all API classes after generator changes

## Development Practices

- Work on feature branches (delete when done)
- Use descriptive branch names (e.g., `fix/api-timeout`)
- Use GitHub mcp, fall back to gh cli
- Write tests first (TDD)
- Test behavior, not implementation (don't test private methods directly)
- Use meaningful test names that describe what's being tested
- Use VCR cassettes for integration tests
- Update CHANGELOG for significant user-facing changes with short, succinct one-liners

### Git

- Run tests, lint, check types before committing (don't commit if any fail)
- Use conventional commit messages (e.g., "feat: add feature")
- 50/72 rule - keep it concise, focus on what/why not how
- Reference or close issues if applicable
- Add yourself as co-author
- **NEVER `git add .`** - stage explicitly
- **NEVER commit changes unless explicitly asked** - always let the user review changes first

## Working with SP-API Specifications

### Amazon specs
- All specifications are stored locally in `selling-partner-api-models/models/`
- If missing, run `bin/generate-code` to download
- Use `rg` (ripgrep) to search
- Use `jq` to parse and extract
- These are the authoritative source for API behavior

#### Parsing OpenAPI Model Files

Each API model file (e.g., `awd_2024-05-09.json`) follows this structure:
- **paths**: API endpoints and operations
  - Each path contains HTTP methods (get, post, put, delete)
  - Each method has `operationId`, `parameters`, `responses`
- **definitions**: Type definitions for request/response objects
  - Watch for circular references (e.g., Type A → Type B → Type A)
- **x-amzn-api-sandbox**: Sandbox response examples (when available)

Common jq commands for exploring models:
```bash
# List all type definitions
jq '.definitions | keys' <api-model>.json

# Find operations that use a specific type
grep -n '"#/definitions/TypeName"' <api-model>.json

# Check for sandbox examples
grep -c "x-amzn-api-sandbox" <api-model>.json

# Extract operation IDs
jq '.paths | .[] | .[] | .operationId' <api-model>.json

# Find circular type dependencies
jq '.definitions.TypeName.properties | to_entries[] | select(.value["$ref"]) | .value["$ref"]' <api-model>.json
```

### Researching SP-API Issues

When researching SP-API functionality or issues:

- Check docs at: https://developer-docs.amazon.com/sp-api/docs/
- GitHub repos: amzn/selling-partner-api-models, amzn/selling-partner-api-samples
- Release notes: https://developer-docs.amazon.com/sp-api/docs/sp-api-release-notes
- Deprecation schedule: https://developer-docs.amazon.com/sp-api/docs/sp-api-deprecation-schedule
- Error handling guide: https://developer-docs.amazon.com/sp-api/docs/error-handling
- Usage plans: https://developer-docs.amazon.com/sp-api/docs/usage-plans-and-rate-limits

### Extracting API Details from Specs

- Operation details: operationId, HTTP method, path parameters
- Request/response schemas and headers
- Error response structures
- Throttling rates (found in "Usage Plan" sections of operation descriptions)
- Look for markdown tables with "Rate (requests per second)" and "Burst" columns in descriptions
- Sandbox-specific endpoints and test data (check for sandbox operations in the specs)

## Common Patterns

### Generated API Classes
See `lib/peddler/apis/catalog_items_2022_04_01.rb` for typical generated API structure:
- Class inherits from `API`
- `.typed` class method enables type parsing
- Methods use keyword arguments with YARD documentation
- Amazon SP-API links in comments reference official docs

### Integration Tests  
See `test/peddler/apis/catalog_items_2022_04_01_test.rb` for standard test patterns:
- Include `FeatureHelpers` for VCR setup and API instantiation
- Use `Marketplace.ids("UK")` for marketplace parameters
- Test methods call API and assert `res.status.success?`
- VCR cassettes auto-record based on test path and filter sensitive data

### Generator Workflow
When modifying code generation:
1. Edit templates in `lib/generator/templates/` (e.g., operation.erb, type.erb)
2. Or modify generator logic in `lib/generator/` (e.g., `operation.rb`, `type.rb`)
3. Run `bin/generate-code` (may take several minutes, run in background)
4. Review generated files in `lib/peddler/apis/` and `lib/peddler/types/`
5. Run tests to verify: `bundle exec rake test`
6. Type check if needed: `bundle exec rake steep`
