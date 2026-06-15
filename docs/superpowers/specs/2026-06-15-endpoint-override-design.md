# Endpoint override (`base_url`) — design

## Context

Peddler can only send requests to two hardcoded destinations: production (`sellingpartnerapi-*.amazon.com`) and Amazon's hosted sandbox (`sandbox.<host>`, via `.sandbox`). Both are built from `Endpoint::REGIONS` and forced through `URI::HTTPS` in `Peddler::Endpoint` (`lib/peddler/endpoint.rb`). There is no supported way to point a client anywhere else, so testing against a local backend requires monkeypatching `Endpoint` or wrapping the injected `HTTP::Client`.

The motivating backend is Amazon's [Sample AI Sandbox for SP-API](https://github.com/amzn/selling-partner-api-samples/tree/main/local-ai-sandbox), announced on 2026-06-09 in [Now Available: Sample AI Sandbox for SP-API (discussion #395)](https://github.com/amzn/selling-partner-api-samples/discussions/395). It is a self-hosted Node/Express service (default `http://localhost:9001`) that validates incoming requests against the SP-API OpenAPI schemas, then either generates a schema-conforming response with an LLM (Claude Haiku on Bedrock), proxies to real SP-API, or — for the Reports API — runs a deterministic local implementation. Pointing Peddler at it (`base_url: "http://localhost:9001"`) lets the generated client exercise real request/response shapes, and its request-validation step is what makes it useful for catching malformed requests the code generator might emit.

The need is general, though: local mocks/stubs (WireMock, Prism), recording proxies, and Amazon regions Peddler does not hardcode all want the same redirect. The override stays neutral about which of these is on the other end.

## Goal

Add a purpose-neutral endpoint override: a caller-supplied `base_url` that redirects all requests for a client to a custom backend. Testing and local development are the primary use, but the override makes no claim about what runs on the other end.

## Why a neutral redirect, not a "sandbox"

`sandbox?` in Peddler is a term of art: it means "pointed at Amazon's *hosted* sandbox," and it carries Amazon-specific behavior — the `must_sandbox!` / `cannot_sandbox!` guards encode which operations that one backend can serve (e.g. FBA Inventory `create_inventory_item` is sandbox-only fixture-seeding; `rotate_application_client_secret` cannot run there). Those assertions are about Amazon's backend, not about "is this a test." A custom backend is a third destination that is neither production nor Amazon's sandbox, so it must not reuse the `sandbox?` flag or its guards. Naming the feature after the mechanism (the endpoint is custom) rather than the downstream (it is mocked) keeps it honest: the same knob legitimately fronts a mock, the AI Sandbox, a proxy, or a real unmapped region.

## Design

### Surface

A `base_url:` keyword on `Peddler::API#initialize` (`lib/peddler/api.rb`), default `nil`, alongside `retries:` and `http:`. It is set-once client configuration, not a per-call toggle, which is why it is a constructor keyword rather than a chainable setter like `.sandbox`.

```ruby
api = Peddler.orders_v0.new(aws_region, access_token, base_url: "http://localhost:9001")
```

`aws_region` remains required and positional. With an override it only feeds the (now bypassed) `Endpoint`; pass any valid region for local testing.

### Validation

Parse the string once at construction with `URI.parse`. Raise `ArgumentError` unless the result is a `URI::HTTP` (which also covers `https`) with a host present, with a message such as `"base_url must be a full http(s) URL, e.g. http://localhost:9001"`. Store the parsed URI in `@base_url` and expose `attr_reader :base_url`.

### Routing

`endpoint_uri` returns the override when set, otherwise the existing production/sandbox logic:

```ruby
def endpoint_uri
  return base_url.dup if base_url
  sandbox? ? endpoint.sandbox : endpoint.production
end
```

`base_url` takes precedence over everything. The `.dup` is required because `request` does `endpoint_uri.tap { |u| u.path = path }`, which would otherwise mutate the stored URI across calls.

### Host header

The `Host` header (set in `http`) derives from `endpoint_uri`'s authority, including a non-default port — so a custom backend is addressed as `localhost:9001`, not bare `localhost`.

### Sandbox interaction

The override and Amazon's sandbox are mutually exclusive, and the sandbox guards step aside under an override:

- `must_sandbox!` and `cannot_sandbox!` each begin with `return if base_url`. Once the caller owns the destination, Peddler's assertions about routing to Amazon's backends no longer apply, so every operation runs against the custom backend (the alternative — keying the guards off a boolean — blocks `must_sandbox!` ops *or* `cannot_sandbox!` ops against the mock, never neither).
- The `.sandbox` setter raises `CannotSandbox, "cannot use sandbox with a custom base_url"` when `base_url` is set. The constructor-keyword shape already prevents the reverse ordering (there is no `base_url` setter to chain after `.sandbox`). It reuses the existing domain error rather than `ArgumentError` so all sandbox-misuse surfaces one rescuable type; the distinct message keeps it unambiguous against the guards' "cannot run in a sandbox".
- `sandbox?` is unchanged and returns `false` on a base_url-only client. It is a predicate, so it answers rather than raises. This yields three clean states from two independent flags:

  | State | `base_url` | `sandbox?` | requests go to |
  |---|---|---|---|
  | Production | nil | false | `sellingpartnerapi-*.amazon.com` |
  | Amazon hosted sandbox | nil | true | `sandbox.<host>` |
  | Custom backend | set | false | the override URL |

`Peddler::Endpoint` is untouched.

## Scope and limitations

- Only scheme, host, and port of `base_url` are honored. Any path is overwritten by the operation path; mount-path prefixes (e.g. `http://host/spapi`) are not supported. This is documented, not enforced, and is acceptable for the AI Sandbox and typical mocks, which serve from the root.
- The retry-backoff branch (`api.rb`) reads `sandbox?` to pick a faster initial delay; a custom backend gets standard backoff. Left as-is — local backends do not throttle, so the 429-only branch will not trigger.
- `api.endpoint` still reports the region-derived `Endpoint` even under an override. `base_url` is the destination override; `endpoint` remains the region configuration.

## Testing

Unit tests in `test/`, no network required:

- `endpoint_uri` returns the override URL.
- `sandbox?` is `false` on a base_url-only client.
- Both `must_sandbox!` and `cannot_sandbox!` operations run (guards bypassed) under an override.
- `.sandbox` raises when `base_url` is set.
- An invalid `base_url` raises `ArgumentError`.
- The `Host` header carries the non-default port.

## Types and docs

- Update the hand-maintained `sig/peddler/api.rbs` for the new keyword and reader (core sig, not generated), and pass `steep check`.
- README: a short note in the testing/sandbox section showing the `base_url:` option.
- CHANGELOG: `### Added` under `## [Unreleased]` (core gem change, SemVer minor).

## Out of scope

- Mount-path prefixes in `base_url`.
- Any built-in integration with the AI Sandbox (spinning it up, request-validation assertions). That is a possible follow-up that builds on this seam.
- Environment-variable configuration (`PEDDLER_ENDPOINT`); code override only.
