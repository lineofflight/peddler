# CLAUDE.md

This file provides guidance when working on this repository.

## About the codebase

This is a Ruby gem called Peddler that provides access to the Amazon Selling Partner API (SP-API). It's a lightweight HTTP client library that allows Ruby developers to interact with Amazon's marketplace APIs for sellers and vendors.

## Commands

### General Development

- Default (tests + lint): `bundle exec rake`
- Lint (with autocorrect, preferred): `bundle exec rubocop -A`

### Code Generation

- Generate API classes from Amazon OpenAPI specs: `bin/generate-code`
- This downloads/updates Amazon SP-API models and regenerates all API classes

### Testing

- Run full test suite: `bundle exec rake test`
- Run single test files: `bundle exec ruby -Itest test/path/to/test_file.rb`
- Run with VCR cassettes for API testing

## Tech Stack

- Ruby 3.2+
- HTTP gem for API requests
- Minitest for testing
- VCR/WebMock for HTTP recording/mocking
- YARD for documentation
- RuboCop for linting
- Appraisal for testing against multiple HTTP gem versions

## Code Style and Architecture Guidelines

### Ruby

- Keep your code idiomatic and direct. Avoid unnecessary complexity
- Design intuitive APIs for your classes and modules. Hide internal details behind private methods
- Use concise and descriptive names
- Organize code into clear modules and classes. Avoid monolithic files

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

## General Development Practices & Expectations

- **Linting**:

  - Run RuboCop after making changes to Ruby files
  - Fix any linting errors and warnings

- **Testing**:

  - Check if there are tests related to the feature you're working on
  - Update them and add robust tests if needed
  - Make sure all tests pass
  - Use VCR cassettes for API integration tests
  - Don't test private methods directly. Test behavior, not implementation

- **Code Generation**:

  - All code in `lib/peddler/apis/` is auto-generated - don't edit manually
  - To check Amazon API specifications, look in `selling-partner-api-models/models/`
  - Generator templates are in `lib/generator/templates/` - edit these to change generated code structure
  - Run `bin/generate-code` after modifying generator code or when Amazon updates their APIs

- **Git Workflow**:

  - Always work on feature branches, never directly on main
  - Create descriptive branch names (e.g., `feature/marketplace-shortcuts`, `fix/api-timeout`)
  - Make your changes and commit with conventional commit messages
  - Push feature branch and create pull request
  - After PR is merged, return to main and clean up

- **Pull Request Workflow**:

  - Use conventional commit messages (e.g., "feat: add new feature", "fix: resolve bug")
  - Follow the 50/72 rule: subject line ≤50 chars, body lines ≤72 chars
  - Submit pull request with clear description of changes
  - Wait for CI checks and code review
  - Keep commits focused and atomic

- **Code Style & Language**:

  - Use casual tone and be concise
  - Avoid excessive commenting - let the code speak for itself
  - Write clear, direct code over clever code

- **Documentation & Housekeeping**:

  - Update the `README.md` if relevant
  - Update the `CHANGELOG.md` when fixing bugs, adding features, or making breaking changes
  - Prune and reorganize these docs (`CLAUDE.md` included) if needed. Don't let them become outdated or cluttered
