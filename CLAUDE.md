# AGENTS
This file provides guidance when working on this repository.

## About the codebase
This is a Ruby gem called Peddler that allows Amazon sellers and vendors to interact with the Selling Partner APIs (SP-API).

### API Design Principles
- **Auto-generate API classes from Amazon's OpenAPI specifications** - never edit `lib/peddler/apis/` directly
- Follow Amazon SP-API naming patterns
- Provide clear error handling
- Handle rate limiting gracefully

### Directory Structure
- `lib/peddler/apis/` - Auto-generated API classes (DO NOT EDIT)
- `lib/generator/` - Code generation system
- `lib/generator/templates/` - Generator ERB templates
- `selling-partner-api-models/` - Amazon's OpenAPI specifications
- `test/` - Test suite
- `bin/` - Executable scripts

## Workflow
### For new features or bug fixes:
1. **Research and understand the requirement**
   - Use Spec Librarian for API specifications
   - Use Domain Expert for best practices and known issues
   - Check existing code patterns in similar files

2. **Plan the implementation**
   - Identify which files need changes
   - Determine if tests should be written first (TDD)
   - Consider impact on existing functionality

3. **Create feature branch** (for significant changes)
   - `git checkout -b feature/description` or `fix/description`

4. **Delegate implementation to Coder**
   - Provide specific requirements and file paths
   - Request TDD if appropriate
   - Let Coder handle tests, implementation, and linting

5. **Verify the implementation**
   - Review Coder's results
   - Run full test suite: `bundle exec rake`
   - Check for any missed edge cases

6. **Update documentation if needed**
   - Update README.md for new features or changed behavior
   - Add entry to CHANGELOG.md for user-facing changes

7. **Commit changes**
   - Stage files explicitly (never use `git add .`)
   - Write a conventional commits: "type: brief description"
   - Follow 50/72 rule
   - Write in lowercase, no need to capitalize proper nouns, class names, or acronyms
   - Include issue number if applicable

8. **Create pull request** (if on feature branch)
   - Provide clear description of changes
   - Link to related issues

## Subagents
**IMPORTANT**: Always delegate to these specialized subagents instead of handling tasks directly. Provide complete context with each invocation.

### When to use each subagent
**Use Coder when:**
- Writing, modifying, or refactoring Ruby code
- Creating or updating tests
- Fixing bugs or test failures
- Running tests and linters
- Implementing new features or methods

**Use Spec Librarian when:**
- Looking up SP-API endpoint details, parameters, or response schemas
- Checking throttling rates or API constraints
- Exploring `selling-partner-api-models/` directory contents
- **Never read/grep SP-API model files directly, always use Spec Librarian**

**Use Domain Expert when:**
- Researching current SP-API documentation or best practices
- Finding recent deprecations or API changes
- Looking up GitHub issues, PRs, or community discussions
- Understanding authentication, rate limiting, or error handling guidance
