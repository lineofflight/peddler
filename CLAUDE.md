# AGENTS

This file provides guidance when working on this repository.

## About the codebase

This is a Ruby gem called Peddler that provides access to the Amazon Selling Partner API (SP-API). It's a lightweight HTTP client library that allows Ruby developers to interact with Amazon's marketplace APIs for sellers and vendors.

### Directory Structure

- `lib/peddler/apis/` - Auto-generated API classes (DO NOT EDIT)
- `lib/generator/` - Code generation system
- `lib/generator/templates/` - Generator ERB templates
- `selling-partner-api-models/` - Amazon's OpenAPI specifications
- `test/` - Test suite
- `bin/` - Executable scripts

## Commands

### General Development

- Default (tests + lint): `bundle exec rake`
- Lint (with autocorrect): `bundle exec rubocop -A`

### Code Generation

- Generate API classes from Amazon OpenAPI specs: `bin/generate-code`
- This downloads/updates Amazon SP-API models and regenerates all API classes

Tips:
- `bin/generate-code` auto-runs RuboCop to format generated code.
- After generation, inspect changes: `git diff --stat` and spot unexpected churn.
- Run tests to validate: `bundle exec rake test` (or `bundle exec rake`).
- Never edit files under `lib/peddler/apis/` manually — adjust templates in `lib/generator/templates/` or rerun the generator instead.

### Testing

- Run full test suite: `bundle exec rake test`
- Run single test files: `bundle exec ruby -Itest test/path/to/test_file.rb`

## Tech Stack

- Ruby 3.2+
- HTTP gem for API requests
- Minitest for testing
- VCR/WebMock for HTTP recording/mocking
- YARD for documentation
- RuboCop for linting

## Code Style and Architecture Guidelines

### Ruby

- Keep your code idiomatic and direct
- Avoid unnecessary complexity
- Hide internal details behind private methods
- Use concise and descriptive names
- Organize code into clear modules and classes
- Avoid monolithic files
- Wrap code and comments at 120 characters

### Code Generation System

- **Almost all API classes are auto-generated** from Amazon's OpenAPI specifications
- Generated code lives in `lib/peddler/apis/` and should not be manually edited
- The generator is in `lib/generator/` and transforms OpenAPI specs into Ruby classes
- OpenAPI models are downloaded to `selling-partner-api-models/` from Amazon's official repository
- When Amazon updates APIs, run `bin/generate-code` to regenerate Ruby wrappers

### API Design

- Follow Amazon SP-API conventions and naming patterns
- Maintain consistent method signatures across API classes
- Use keyword arguments for optional parameters
- Provide clear error handling and meaningful error messages
- Support both sandbox and production environments
- Handle rate limiting gracefully
- Implement exponential backoff for retries
- Parse and handle specific Amazon error responses

## Development Practices

### Testing

- Use Amazon's sandbox API whenever possible for testing
- Use VCR cassettes for recording/replaying HTTP interactions when sandbox isn't available or for consistent test data
- Test behavior, not implementation (don't test private methods directly)
- Check Amazon API specifications in `selling-partner-api-models/models/`

### Git & Pull Requests

- Work on feature branches
- Use descriptive branch names (e.g., `feature/marketplace-shortcuts`, `fix/api-timeout`)
- Use conventional commit messages (e.g., "feat: add new feature", "fix: resolve bug")
- **NEVER use `git add .`** - always stage files explicitly by name

### Documentation

- Keep `README.md` and `CHANGELOG.md` up-to-date
- Use YARD documentation for public methods only
- Avoid excessive commenting - let the code speak for itself

## Subagents

- Spec Librarian — answers strictly from local SP‑API OpenAPI models in `selling-partner-api-models/` with precise citations.
- Domain Expert — researches SP‑API across the web and GitHub; synthesizes docs, issues/PRs, and announcements with links.

### Examples

Spec Librarian
- Required query params (Orders v0):
  - “List required query params for Orders v0 listOrders. Include citations.”
- Throttling defaults:
  - “What throttling (rate/burst) applies to Reports 2021-06-30 getReport? Include citations.”
- Error codes:
  - “Enumerate 4xx/5xx responses for Feeds 2021-06-30 createFeedDocument. Include citations.”

Domain Expert
- Deprecations summary:
  - “Summarize Feeds API deprecations over the last 6 months with links.”
- Compare guidance:
  - “Compare throttling guidance for Reports vs Feeds in official docs; link sources and quote key lines.”
- Repo issues (GitHub MCP):
  - “Search amzn/selling-partner-api-models for ‘GET_FLAT_FILE_OPEN_LISTINGS_DATA’ issues/PRs and summarize with links.”
