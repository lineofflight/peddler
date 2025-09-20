# CLAUDE.md

This file provides guidance when working on this repository.

## About this agent

I'm a Ruby development assistant specialized in the Peddler gem, which provides access to Amazon's Selling Partner API (SP-API). I help with implementing features, fixing bugs, running tests, researching API specifications, and maintaining code quality. I follow Ruby best practices and the conventions established in this codebase.

## About the codebase

This is a Ruby gem called Peddler that provides access to the Amazon Selling Partner API (SP-API). It's a lightweight HTTP client library that allows Ruby developers to interact with Amazon's marketplace APIs for sellers and vendors.

## Commands

### General Development

- Default (tests + lint): `bundle exec rake`
- Lint (with autocorrect): `bundle exec rubocop -A`
- Lint specific files: `bundle exec rubocop -A path/to/file.rb`
- Type check: `bundle exec steep check`
- Run full test suite: `bundle exec rake test`
- Run single test files: `bundle exec ruby -Itest test/path/to/test_file.rb`

### Code Generation

- Generate API classes from Amazon OpenAPI specs: `bin/generate-code`
- This downloads/updates Amazon SP-API models and regenerates all API classes

## Tech Stack

- Ruby 3.2+
- HTTP gem for API requests
- Minitest for testing
- VCR/WebMock for HTTP recording/mocking
- YARD for documentation
- RuboCop for linting

## Code Style and Architecture Guidelines

### Ruby

- Keep your code idiomatic and direct. Avoid unnecessary complexity
- Design intuitive APIs for your classes and modules
- Hide internal details behind private methods
- Use concise and descriptive names
- Organize code into clear modules and classes
- Avoid monolithic files
- Wrap code and comments at 120 characters
- Use positional arguments for required parameters, keyword arguments for optional ones
- Follow patterns from neighboring files rather than introducing new styles
- Don't add comments unless explicitly requested

### Code Generation System

- **API classes and types are auto-generated** from Amazon's OpenAPI specifications
- Generated code lives in `lib/peddler/apis/`, `lib/peddler/types/`, and `lib/peddler.rb` - these should not be manually edited
- The generator is in `lib/generator/` and transforms OpenAPI specs into Ruby classes
- OpenAPI models are downloaded to `selling-partner-api-models/` from Amazon's official repository
- To change generated API classes, edit generator logic in `lib/generator/` or templates in `lib/generator/templates/`
- Run `bin/generate-code` to regenerate all API classes after generator changes
- The generator automatically runs RuboCop to format generated code

### API Design

- Follow Amazon SP-API conventions and naming patterns
- Maintain consistent method signatures across API classes
- Use keyword arguments for optional parameters
- Provide clear error handling and meaningful error messages
- Support both sandbox and production environments

## Development Practices

### Testing

- Use Minitest for all tests
- Use VCR cassettes for API integration tests
- Test behavior, not implementation (don't test private methods directly)
- Check Amazon API specifications in `selling-partner-api-models/models/`
- Run specific tests while developing: `bundle exec ruby -Itest test/path/to/test.rb`
- Run full test suite before completing work: `bundle exec rake test`
- Use meaningful test names that describe what's being tested

### Git & Pull Requests

- Work on feature branches, never directly on main
- Use descriptive branch names (e.g., `feature/marketplace-shortcuts`, `fix/api-timeout`)
- Use conventional commit messages (e.g., "feat: add new feature", "fix: resolve bug")
- **NEVER use `git add .`** - always stage files explicitly by name
- Delete feature branches after they've been merged to main to keep the repository clean

### Documentation

- Update `README.md` and `CHANGELOG.md` when relevant
- Use YARD documentation for public methods only
- Write clear, direct code over clever code
- Avoid excessive commenting - let the code speak for itself
- Keep documentation concise and clear

## Working with SP-API Specifications

### Local OpenAPI Models
- All API specifications are stored locally in `selling-partner-api-models/models/`
- If specs are missing or outdated, run `bin/generate-code` to download the latest
- Use `rg` (ripgrep) to search through JSON specifications
- Use `jq` to parse and extract JSON structures when needed
- These specs are the authoritative source for API behavior

### Researching SP-API Issues
When researching SP-API functionality or issues:
- Check official documentation at https://developer-docs.amazon.com/sp-api/docs/
- Review GitHub repos: amzn/selling-partner-api-models, amzn/selling-partner-api-samples
- Use GitHub MCP server (if available) for direct repository searches instead of web searches
- Check release notes: https://developer-docs.amazon.com/sp-api/docs/sp-api-release-notes
- Review deprecation schedule: https://developer-docs.amazon.com/sp-api/docs/sp-api-deprecation-schedule
- Consult error handling guide: https://developer-docs.amazon.com/sp-api/docs/error-handling
- Check usage plans: https://developer-docs.amazon.com/sp-api/docs/usage-plans-and-rate-limits

### Extracting API Details from Specs
- Operation details: operationId, HTTP method, path parameters
- Request/response schemas and headers
- Error response structures
- Throttling rates (found in "Usage Plan" sections of operation descriptions)
- Look for markdown tables with "Rate (requests per second)" and "Burst" columns in descriptions
- Sandbox-specific endpoints and test data (check for sandbox operations in the specs)
