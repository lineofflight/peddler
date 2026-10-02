# Supplemental Rust model generation

`generate_supplemental(checkout_root, revision)` emits 55 model modules and 4
family indexes. The default Rust generator and `--models-only` export include
these outputs; `--check` validates them without writing. The audited source
paths, hashes and Ruby-compatible namespace names are in
`crates/peddler-codegen/supplemental-sources.json`.

Generation needs Rust, the pinned Amazon checkout, Ruby/Bundler and the locked
`graphql` and ActiveSupport gems (`bundle install`). Full generation also needs
the locked Node Swagger converter. `bundle exec rake generate:rust:setup` checks
these dependencies. SDK builds and decoding use committed Rust files and require
neither Ruby, Node, SDL, JSON schemas nor code generation.

`convert.rb` extends the existing `Generator::GraphqlTypeExtractor`, using the
GraphQL gem's SDL parser. Every selected response field is optional, including
non-null SDL fields. Nested list element nullability is retained. `Int`/`Long`
map to signed 32/64-bit integers, `Float` to precise `serde_json::Number`, and
String/ID/Date/DateTime to strings. Enum values remain open strings with known
values documented. `Response` models the root query selection, without a
GraphQL `data`/`errors` envelope. There is no query builder or selection validator.
`Option` represents absent/null fields together, so non-null field annotations
do not prohibit a top-level explicit null; non-null list elements are enforced.
The existing Ruby parsing models and all 4 introspection resources are retained.

JSON schemas retain their full root and envelope key casing. References resolve
locally within the audited schema inventory, including external files and root
references; unknown or network references fail. The 4 existing notification
patches run after root resolution. The CLI checks all schema files and patches
are tracked and clean, the source inventory matches Git at the pin, and SHA256
matches the audit for the production pin. The pinned Tracking API file consumed
by the shipment repair is also covered by the existing API integrity checks.

Normalization reuses the API generator's numeric precision, open string enums,
default removal and optional-array policy. Narrow additional adaptations are:

- Explicit `additionalProperties: true` becomes equivalent `{}` so Typify emits
  extension maps rather than discarding them.
- Conflicting inline titles are removed only when they describe different schema
  shapes, preventing unrelated notification types from sharing one Rust name.
- Amazon's singleton `items` array with `additionalItems: true` is interpreted as
  the homogeneous list described by B2B/PricingHealth. Real tuples are retained.
- Feed base properties/required fields are distributed into `oneOf` branches.
  Operation constants stay closed, and generated Serde checks preserve forbidden
  fields. UPDATE/PARTIAL_UPDATE/PATCH retain their branch-required fields.
- The tax invoice eligibility `message.contains` rule is enforced by a generated
  Serde helper requiring an `en-US` entry when a non-null message list is present.

The pinned ShipmentTrackingMilestoneChanged schema has an unresolved root
reference and empty definitions. Current upstream has the same defect. An exact
source-specific repair reuses the pinned Tracking API's `TrackingDetail` and its
reference closure, plus the established notification envelope keys. Envelope and
payload wrapper fields are conservatively optional; canonical tracking-type
required fields are retained. Every repaired object preserves extension fields.
The repair never applies to other unresolved references, and its example
roundtrip is tested. The sources and existing Ruby outputs are never modified.

These are data models with Serde decoding, not a complete JSON Schema validator.
Typify does not enforce every schema constraint, including collection bounds,
object property counts and arbitrary cross-field rules. The feed and localized
message guards above cover constraints whose omission changed the audited
schema's required/forbidden fields. Signed document transfers and lifecycle
polling belong to the SDK helper/runtime work.
