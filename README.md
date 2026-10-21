# Peddler

Peddler is a Ruby gem and a Rust crate for the [Amazon Selling Partner API (SP-API)][api-docs]. The SP-API enables Amazon sellers and vendors to programmatically access their data on orders, shipments, payments, and more.

Both are generated from Amazon's latest OpenAPI models. A nightly job tracks Amazon's spec changes, so new endpoints and fields land shortly after Amazon publishes them. Model changes are not considered breaking and don't trigger a major version bump.

Both cover all SP-API endpoints, reports, notifications and feeds, and run on 1 Rust core: the crate is the core, and the gem ships it as a native extension.

![Peddler](https://github.com/lineofflight/peddler/blob/main/images/peddler.jpg?raw=true)

Coming from Peddler 5? See [UPGRADING.md](UPGRADING.md).

## Quick start

| | Ruby | Rust |
| --- | --- | --- |
| Package | [`peddler` gem](https://rubygems.org/gems/peddler) | [`peddler` crate](https://crates.io/crates/peddler) |
| Needs | Ruby 3.3 or later | Rust 1.88 or later |
| API docs | [lineofflight.github.io/peddler](https://lineofflight.github.io/peddler/) | [docs.rs/peddler](https://docs.rs/peddler) |

Both examples read your [LWA credentials][view-credentials] from `LWA_CLIENT_ID` and `LWA_CLIENT_SECRET` and a seller's refresh token from `REFRESH_TOKEN`, then list the seller's marketplaces.

### Ruby

Add to your Gemfile.

```ruby
gem "peddler"
```

```ruby
require "peddler"

lwa = Peddler::LWA.new
access_token = lwa.refresh(refresh_token: ENV.fetch("REFRESH_TOKEN")).access_token
client = Peddler::Client.new(region: "eu-west-1", access_token: access_token)

response = client.sellers.get_marketplace_participations
response.parse.payload.each { |participation| puts participation.marketplace.name }
```

The [Ruby guide](RUBY.md) covers the rest.

### Rust

Add the crate and [Tokio](https://tokio.rs), the async runtime its calls run on.

```shell
cargo add peddler
cargo add tokio --features macros,rt-multi-thread
```

```rust
use peddler::{Client, apis::sellers_v1, auth::LwaClient};
use std::env;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let lwa = LwaClient::new(&env::var("LWA_CLIENT_ID")?, &env::var("LWA_CLIENT_SECRET")?)?;
    let tokens = lwa.refresh(&env::var("REFRESH_TOKEN")?).await?;
    let client = Client::new("https://sellingpartnerapi-eu.amazon.com", &tokens.access_token)?;

    let params = sellers_v1::GetMarketplaceParticipationsParams::new();
    let response = sellers_v1::get_marketplace_participations(&client, params).await?;
    println!("{}", response.raw.status);
    if let Some(participations) = response.json()?.payload {
        for participation in participations.iter() {
            println!("{}", participation.marketplace.name);
        }
    }
    Ok(())
}
```

An HTTP error status is a response, not an `Err`, so the example prints the status. The [crate's README](crates/peddler/README.md) is the Rust guide.

## Guides

- [Ruby guide](RUBY.md): installing the gem, tokens, calls, errors, documents and tests
- [Rust guide](crates/peddler/README.md): installing the crate, tokens, calls, errors and documents
- [Upgrading](UPGRADING.md): from Peddler 5 to 6, and from 4 to 5

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

`rake test` builds the extension first. Types are inline RBS comments in the Ruby files, and RDoc builds the documentation from the same comments. `rake generate` writes the signatures the gem ships into `sig/inline`, and `rake rbs:export` does after a change to hand-written code. The generators are described in [lib/generator/README.md](lib/generator/README.md) and [crates/peddler-codegen/README.md](crates/peddler-codegen/README.md). A release is made by hand: see [RELEASING.md](RELEASING.md).

## License

Peddler is released under the [MIT License](LICENSE).

The precompiled gems carry the notices of the third-party code they link: see [Licenses](RUBY.md#licenses) in the Ruby guide.

[api-docs]: https://developer-docs.amazon.com/sp-api/docs/welcome
[view-credentials]: https://developer-docs.amazon.com/sp-api/docs/viewing-your-application-information-and-credentials
