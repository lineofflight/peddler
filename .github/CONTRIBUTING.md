## Submitting an Issue

Only submit issues that are specific to Peddler. Otherwise, reach out to Amazon [Developer Support][] or find help on
their [GitHub Discussions][].

## Development

Development needs a stable Rust toolchain next to Ruby.

```bash
# Setup
bundle install
bundle exec rbs collection install

# Build the native extension into tmp/native
bundle exec rake native:build

# Run tests and linting
bundle exec rake

# Run tests only
bundle exec rake test

# Test and lint the crate
cargo test -p peddler --locked
cargo clippy -p peddler --all-targets --locked -- -D warnings

# Regenerate the Ruby and Rust code from Amazon's OpenAPI specs
bundle exec rake generate

# Type check with Steep
bundle exec steep check --severity-level=hint

# Build the documentation site into doc/ with RDoc
bundle exec rake rdoc
```

`rake test` builds the extension first. Types are inline RBS comments in the Ruby files, and RDoc builds the
documentation from the same comments. `rake generate` writes the signatures the gem ships into `sig/inline`, and
`rake rbs:export` does after a change to hand-written code. The generators are described in
[lib/generator/README.md](../lib/generator/README.md) and
[crates/peddler-codegen/README.md](../crates/peddler-codegen/README.md). A release is made by hand: see
[RELEASING.md](../RELEASING.md).

[Developer Support]: https://developer.amazonservices.com/support
[GitHub Discussions]: https://github.com/amzn/selling-partner-api-models/discussions
