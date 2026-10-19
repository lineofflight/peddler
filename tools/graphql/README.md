# Rust models for reports, feeds, notifications and Data Kiosk

Amazon describes report documents, feed documents and notifications as JSON Schema, and Data Kiosk as GraphQL. [`peddler-codegen`](../../crates/peddler-codegen/README.md) turns the 55 schemas that `crates/peddler-codegen/supplemental-sources.json` lists into Rust models: 1 module for each schema and an index for each of the 4 families, under `crates/peddler/src/{reports,feeds,notifications,data_kiosk}/`.

They are generated with the rest of the Rust code, by `bundle exec rake generate:rust`, and checked by `bundle exec rake generate:rust:verify`. Building the crate or the gem needs none of this: the models are committed.

## Data Kiosk

`convert.rb` in this directory turns a GraphQL schema into JSON Schema definitions, which the generator then treats like any other schema. The generator runs it with `bundle exec ruby`, so generation needs `bundle install` and the `graphql` gem. It builds on the extractor the Ruby generator uses, `lib/generator/parsers/graphql_type_extractor.rb`.

```sh
bundle exec ruby tools/graphql/convert.rb selling-partner-api-models/schemas/data-kiosk/analytics_salesAndTraffic_2024_04_24.graphql
```

| GraphQL | Rust |
| --- | --- |
| `String`, `ID`, `Date`, `DateTime` | `String` |
| `Int` | `i32` |
| `Long` | `i64` |
| `Float` | `serde_json::Number`, with every digit |
| `Boolean` | `bool` |
| an enum | a string, with the known values in its documentation |
| a list | `Vec`, whose elements may be null unless the schema says otherwise |

Every field of an object is optional, also one that GraphQL marks non-null, because a query selects only some fields. `Response` models the root of a query's result, without GraphQL's `data` and `errors` envelope. There is no query builder and no check of a query against the schema.

## JSON schemas

A schema keeps its field names as Amazon spells them. A reference is resolved inside the listed schemas, also one to another file. A reference to anything else, or to a URL, fails generation.

The models follow the rules of the API models: a number keeps every digit, a string enum stays open and a default is removed. A few schemas need more:

- `additionalProperties: true` is kept as a map of the extra fields.
- Titles that 2 different inline shapes share are dropped, so that unrelated types don't get 1 Rust name.
- An `items` array with a single schema and `additionalItems: true` is read as a list of that schema, which is what the B2B and Pricing Health notifications mean by it.
- A feed schema that refines its base by `operationType` becomes 1 type per operation. Each refuses the fields its operation forbids.
- The tax invoice eligibility notification requires an `en-US` entry among its messages. The generated type checks that when it decodes.
- The 4 patches in `lib/generator/patches/` are applied to the notification schemas they name, as in the Ruby generator.

## What the models are not

They decode JSON into types. They are not a JSON Schema validator: array lengths, property counts and most rules that span several fields are not checked.
