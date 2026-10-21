# Generator System

This generator writes Peddler's typed Ruby models from Amazon's specs: the response types of every API, and the types of notifications, reports, feeds and Data Kiosk schemas.

Peddler has two generators. The Rust one, [`peddler-codegen`](../../crates/peddler-codegen/README.md), writes the Rust core and the Ruby method of each operation. This one writes what `response.parse` returns.

Entry point: `lib/generator.rb`

## What it reads

- `selling-partner-api-models/`, a checkout of [Amazon's models][models] at the revision in `selling-partner-api-models.sha`: the OpenAPI models under `models/`, and the JSON and GraphQL schemas under `schemas/`
- `crates/peddler-codegen/operation-inventory.json`, which the Rust generator writes. It names every operation and the model of its response
- `lib/generator/patches/`, JSON patches for known mistakes in Amazon's notification schemas

## What it writes

| Path | Holds |
| --- | --- |
| `lib/peddler.rb` | the entry point, with the lookup from an API to its models |
| `lib/peddler/apis/<api>.rb` | the module of an API version, with the typed model of each operation's response |
| `lib/peddler/apis/<api>/` | the types of that API |
| `lib/peddler/{notifications,reports,feeds,data_kiosk}/` | the types of the other schemas |
| `sig/peddler/{apis,notifications,reports,feeds,data_kiosk}/` | the RBS signatures of those types. The entry point carries its own as inline RBS. |

Every Ruby file it writes carries a comment that starts `# This file is generated.`

It doesn't write the operation methods, `lib/peddler/native/apis.rb`, their documentation or their signatures. Those come from the Rust generator.

## Running it

```sh
# Both generators, at the pinned revision
bundle exec rake generate

# Regenerate at the pin and fail if a committed file changes
bundle exec rake generate:verify

# Move the pin to Amazon's latest revision, then regenerate
bundle exec rake generate:update
```

`rake generate` runs the Rust generator first, because this one reads its inventory. It needs a Rust toolchain. It ends with `rake rbs:export`, which writes `sig/inline` from the Ruby that carries inline RBS, and `generate:verify` fails if that changes too.

To run one part of this generator, at the pinned revision and without Rust:

```sh
bundle exec rake generate:apis
bundle exec rake generate:notifications
bundle exec rake generate:reports
bundle exec rake generate:feeds
bundle exec rake generate:data_kiosk
bundle exec rake generate:entrypoints
```

A part doesn't export: run `bundle exec rake rbs:export` after `generate:entrypoints`.

Generated code is committed and corresponds to the pinned revision. A change to the generator must leave the output as it is, or land the changed output in the same commit. `generate:verify` is the test of that, more than the unit tests of the generator's parts. The nightly `update-models` workflow runs `generate:update`.

## Why this generator exists

Peddler generates its types with a generator of its own, not with [openapi-generator][oag] or swagger-codegen.

- openapi-generator's Ruby generator doesn't support `oneOf`, `anyOf` and `allOf`. Amazon's specs use `allOf` (see `merge_from_all_of` in `builders/type.rb`) and `anyOf` (see `parsers/json_schema_extractor.rb`).
- Its Ruby output is untyped: no RBS, no `Structure` models, no Ruby naming. The typed models are what this generator is for.
- Amazon's own SDK is built with openapi-generator and has no Ruby target.
- Adopting it would still need a set of forked templates and a layer that repairs Amazon's specs first. That is not less to maintain.

What this generator does that a general one won't:

- It turns Amazon's many money shapes into a single `Peddler::Money`.
- It breaks cycles between types, and only those, by naming a class lazily.
- It applies JSON patches for known mistakes in Amazon's schemas.
- It writes RBS by loading the classes it generated and asking the `structure` gem for their attributes.
- It handles the JSON schemas of notifications, reports and feeds, and Data Kiosk's GraphQL.

## Directory structure

### Orchestrators

- **`api.rb`**: each API's types and its response lookup, from an OpenAPI model
- **`notification.rb`**: notification types, from JSON schemas
- **`report.rb`**: report types, from JSON schemas
- **`feed.rb`**: feed types, from JSON schemas
- **`data_kiosk.rb`**: Data Kiosk types, from GraphQL schemas
- **`entrypoint.rb`**: `lib/peddler.rb`
- **`specs.rb`**: the checkout of Amazon's models, and the pin

### Builders (`builders/`)

- **`type.rb`**: builds a type class. Every orchestrator uses it
- **`operation.rb`**: reads an operation's response model
- **`response_model.rb`**: finds the model of a successful response

### Parsers (`parsers/`)

- **`json_schema_extractor.rb`**: extracts nested types from JSON schemas
- **`graphql_type_extractor.rb`**: extracts types from a GraphQL schema
- **`path.rb`**: collects the operations of an OpenAPI path

### Resolvers (`resolvers/`)

- **`type_resolver.rb`**: maps OpenAPI types to Ruby types
- **`api_name_resolver.rb`**: derives an API's name and version from its file path

### Analyzers (`analyzers/`)

- **`circular_dependency_detector.rb`**: finds cycles between types

### Support (`support/`)

- **`config.rb`**: paths and constants
- **`logger.rb`**: logging
- **`file_writer.rb`**: writes files, formats them and sorts RBS
- **`formatter.rb`**: formats comments
- **`known_values.rb`**: lists an enum's values in the comment of a field
- **`naming.rb`**: names of classes and attributes
- **`money_detector.rb`**: recognizes a money shape
- **`schema_helpers.rb`**: schema handling shared by notifications, reports, feeds and types
- **`schema_generator.rb`**: the steps the schema orchestrators share
- **`introspection_loader.rb`**: a Zeitwerk loader for the generated classes

### Templates and signatures

- **`templates/`**: ERB templates for Ruby files
- **`rbs/`**: RBS generation
  - `unified.rb`: an API's lookup and types
  - `types.rb`: types only, for notifications, reports, feeds and Data Kiosk
  - `entrypoint.rb`: the entry point
- **`patches/`**: the JSON patches

## How it works

1. **Sync specs**: `Specs` checks out Amazon's models at the pinned revision.
2. **Generate code**: each orchestrator reads its specs, extracts the type definitions, builds a Ruby class for each and writes the module that holds them from an ERB template. `API` also writes the lookup from each operation to its response model.
3. **Generate RBS**: each orchestrator loads the classes it wrote and writes their signatures.
4. **Format**: RuboCop formats the Ruby files, and the RBS files are sorted.

## Key patterns

- **Parallel generation**: the orchestrators process their specs with `Parallel.each`.
- **Type resolution**: `TypeResolver` maps OpenAPI and JSON Schema types to Ruby types.
- **Circular dependencies**: `CircularDependencyDetector` finds them, and the type builder names one class of each cycle lazily, as a String.
- **Introspection**: `IntrospectionLoader` loads the generated classes, so that the `structure` gem can describe them for RBS.

[models]: https://github.com/amzn/selling-partner-api-models
[oag]: https://openapi-generator.tech/docs/generators/ruby/
