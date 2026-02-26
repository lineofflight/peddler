# Changelog

All notable changes to this project will be documented in this file. This project adheres to [Semantic Versioning](http://semver.org/). Changes to Amazon's SP-API models are not considered breaking and do not trigger a major version bump.

## [Unreleased]

## [5.3.0] - 2026-02-26

### Added

- Add Data Kiosk Sales and Traffic 2024-04-24 query

### Removed

- Remove fulfillment plan endpoints from Orders v0
- Remove shipment confirmation endpoints from Vendor Shipments v1
- Remove Amazon Motors endpoints from Messaging v1

## [5.2.0] - 2026-01-29

### Added

- Add Orders API 2026-01-01

## [5.1.0] - 2026-01-26

### Changed

- Accept pre-configured HTTP client in `API#initialize`

### Removed

- Remove `API#use`, `API#via`, and `API#retriable` methods

## [5.0.0] - 2025-11-30

### Added

- Add Data Kiosk API support with four schema versions
- Type-safe parsing for Data Kiosk GraphQL responses
- Parse SP-API notifications with type-safe data structures
- Parse SP-API feed schemas with type-safe data structures
- Parse SP-API report schemas with type-safe data structures
- Add notification parse tests with fixtures from Amazon docs
- Add typed response for `Peddler::LWA.request`
- Integrate Zeitwerk for autoloading (improves startup time)

### Changed

- All HTTP errors (4xx and 5xx) now raise `Peddler::Error` exceptions
- Simplify typed response handling - `parse` always returns typed responses, use `to_h` for raw Hash
- Make Nokogiri a required dependency for S3 error parsing
- Rename `Peddler::Token` to `Peddler::LWA` for clarity and consistency
- Move API typed parsers from `Peddler::Types::*` to `Peddler::APIs::*` namespace

### Fixed

- Fix notification schemas marking optional fields as required
- Fix Zeitwerk inflection for plural acronyms (URLs, APIs)
- Fix incorrect type generation for B2B notification objects
- Patch missing and incorrect data in notification schemas from Amazon's OpenAPI models
- Separate colliding APIs in external-fulfillment and finances directories

### Removed

- Remove deprecated `Response.decorate` method (use `Response.new` instead)
- Remove obsolete `raise_on_server_errors` configuration option
- Remove `API#through` alias (use `API#via` instead)
- Remove deprecated `Token::Error` class
- Remove `typed` helpers (use `parse` directly)

## [4.9.0] - 2025-10-01

### Changed

- Upgrade structure gem to 4.0 for improved optional attribute handling
- Regenerate all type classes with attribute? for optional fields
- Treat OpenAPI types with additionalProperties as Hash instead of generating empty Structure classes

### Fixed

- Fix missing sandbox rules in some API methods
- Generate X-Amz-Date header per request instead of memoizing stale timestamps

## [4.8.0] - 2025-09-22

### Changed

- Replace Money gem with lightweight Data class for money types
- Simplify RBS setup with local signatures instead of external collections

### Fixed

- Fix NoMethodError when requiring individual API files without main peddler.rb

### Removed

- Remove Money gem dependency

## [4.7.0] - 2025-09-21

### Added

- Add RBS type signatures for all API classes and types
- Add auto-generation of RBS signatures from OpenAPI specifications
- Add Steep type checking support with `bundle exec steep check`

### Fixed

- Fix all type checking issues across the codebase

### Changed

- Refactor code generator and templates for cleaner output

## [4.6.1] - 2025-09-15

### Fixed

- Strip `is_` prefix from boolean attributes

## [4.6.0] - 2025-09-15

### Added

- Add typed responses with `typed` method for type-safe API responses using Structure gem

## [4.5.0] - 2025-06-26

### Added

- Add `download_report_document` helper method to Reports API (2021-06-30)
- Handle Amazon S3 errors
- Add configuration option `raise_on_server_errors` to opt into v5.0 error handling behavior

### Changed

- Update Amazon API models with new Customer Feedback API (2024-06-01) and updates to Finances (2024-06-19), Orders (v0), and Vendor Shipments (v1) APIs

### Deprecated

- **Server errors (5xx) returning response objects** - This behavior is deprecated. In v5.0, all HTTP errors (4xx and 5xx) will raise `Peddler::Error` exceptions. Set `Peddler.raise_on_server_errors = true` to adopt the new behavior now.

### Fixed

- Handle transient token errors

## [4.4.0] - 2025-05-30

### Added

- Handle array parameters
- Add shortcuts for the latest api version

### Changed

- Handle token errors in Peddler::Error

### Fixed

- URL-encode path parameters in generated API

## [4.3.1] - 2025-05-04

### Fixed

- Use response instead of cause in Token::Error for semantic correctness

## [4.3.0] - 2025-05-02

### Added

- New Seller Wallet API

## [4.2.0] - 2025-03-18

### Added

- New Finances version
- New Vehicles API
- Changes to various APIs

### Fixed

- Fix duplicate method definition in ShippingV2 API

### [4.1.1] - 2024-12-17

### Added

- Make retries configurable

### Fixed

- Meter requests only if a rate limit is given

## [4.0.1] - 2024-12-13

### Fixed

- Add kwargs to define_method to fix argument error when calling HTTP methods
- Normalize error class names from screaming snake case

## [4.0.0] - 2024-12-13

### Changed

- Pluralize the namespaces `APIs` and `Errors` for consistency. Direct references will need to be updated

### Added

- Allow custom parser
- Marketplace.id and Marketplace.ids shorthands
- Add new operations to Fulfillment Inbound v2024-03-20
- Add upload_feed_document method to Feeds API
- Add Ireland marketplace

### Fixed

- Set failed http response in a custom attribute instead of cause

## [3.0.0] - 2024-10-04

### Added

- Add new APIS (Application Integrations 2024-04-01, Finances 2024-06-19, Invoices 2024-06-19)
- Implement sandbox mode
- Add convenience methods for the APIs at the top level
- Add marketplace model

### Changed

- Complete rewrite—now wraps the Selling Partner API (SP-API)

### Fixed

- Refactor token to handle authorization workflows

## [2.4.5] - 2021-04-23

### Added

- Add Poland endpoint

## [2.4.4] - 2020-10-30

### Added

- Add Sweden endpoint

## [2.4.3] - 2020-08-07

### Fixed

- Fix file permission issue in published gem

## [2.4.2] - 2020-08-03 [YANKED]

### Fixed

- Work around another bad charset name?
- Parse XML browse tree data reports

### Removed

- Do not support Ruby 2.4

## [2.4.1] - 2020-05-05

### Added

- Support for binary files in the Feeds API

## [2.4.0] - 2020-04-13

### Added

- Add Netherlands endpoint

### Fixed

- Work around bad charset name

## [2.3.0] - 2020-01-27

### Added

- Add Egypt, Saudi Arabia, and Singapore endpoints
- Add Easy Ship API
- Add Shipment Invoicing API
- Support Ruby 2.7

### Removed

- Remove China. It is no longer supported starting 1st October 2019.
- Remove Off-Amazon Payments. This is no longer under the MWS umbrella and has its own official Ruby client.

## [2.2.0] - 2019-09-04

### Added

- Add Amazon United Arab Emirates to marketplaces.

### Fixed

- Fix query format in FulfillmentOutboundShipment#GetFulfillmentPreview.
- Handle missing error response in HTTP status error

## [2.1.1] - 2019-04-05

### Fixed

- Parse flat files correctly if charset passed in response header.

### Removed

- Do not support Ruby 2.3.

## [2.1.0] - 2019-02-15

### Added

- Add Amazon Turkey to marketplaces.

### Fixed

- Work around upstream bug in FulfillmentInboundShipment#get_prep_instructions_for_asin.

## [2.0.4] - 2018-07-02

### Fixed

- Properly massage inbound shipment items in FulfillmentInboundShipment#create_inbound_shipment and FulfillmentInboundShipment#update_inbound_shipment_plan.
- Require inbound shipment items argument.

## [2.0.3] - 2018-06-29

### Fixed

- Structure nested structured lists.

## [2.0.2] - 2018-06-22

### Fixed

- Parse flat files with blank rows.

## [2.0.1] - 2018-06-01

### Fixed

- Fix FulfillmentInboundShipment#create_inbound_shipment_plan.

## [2.0.0] - 2018-03-02

### Added

- Allow using country code instead of ID when setting marketplace in a client.

### Changed

- Do not default to primary marketplace in any operation.
- Shorten #primary_marketplace_id to #marketplace in client.
- Use custom errors for MWS specific errors.
- Update list of error codes created up front.
- Add mws prefix to MWS header accessors.
- Fix parameters of FulfillmentOutboundShipment#list_all_fulfillment_orders.

### Removed

- Remove custom error callbacks.
- Remove deprecated methods in Client.
- Remove ENV var for Client#primary_marketplace_id.
- Remove ENV var for Client#merchant_id.
- Do not support Ruby 2.2.

## [1.6.7] - 2018-03-02

### Added

- Improve enabling new error handler.

### Changed

- Do not support Ruby 2.1.

## [1.6.6] - 2018-02-22

### Changed

- Bump mininum version of Jeff dependency because Amazon no longer supports the
  deprecated Content-MD5 header.
- Leave it up to user to use Hash#dig polyfill.
- Remove errors there's no value in creating up front.

## [1.6.5] - 2017-12-08

### Changed

- Optional arguments when instantiating errors for more legible tests.

## [1.6.4] - 2017-12-08

### Added

- Add InternalError and InvalidAccessKeyId error codes.

## [1.6.3] - 2017-09-25

### Added

- Add Amazon Brazil marketplace.

### Changed

- Updated hostnames for MWS endpoints.

## [1.6.2] - 2017-09-13

### Added

- Add Amazon Australia marketplace.
- Add ListReturnReasonCodes and CreateFulfillmentReturn operations to the
  FulfillmentOutboundShipment client.

### Fixed

- Parse UTF8-encoded flat files correctly.

## [1.6.1] - 2017-05-24

### Changed

- Scrub body of flat file response.
- Encode flat file request bodies.
- Clear request body after posting successfully.

### Fixed

- Handle when headers have no quota metadata.

## [1.6.0] - 2017-02-15

### Added

- Parse MWS headers.
- Delegate to Hash#dig in Peddler::XMLParser.
- Add InvalidRequest and MalformedInput to known error codes.

### Changed

- Use ContentMD5Value parameter instead of Content-MD5 header. To retain old
  behaviour, peg version of the Jeff gem to ~> 1.5.

### Fixed

- Post multibyte characters correctly.
- Fix parsing XML with 'Message'.

## [1.5.0] - 2017-01-13

### Added

- Add GetInboundGuidanceForSKU, GetInboundGuidanceForASIN, GetPreorderInfo,
  ConfirmPreorder, GetPrepInstructionsForSKU, GetPrepInstructionsForASIN,
  GetUniquePackageLabels, and GetPalletLabels operations to the
  FullfillmentInboundShipment client.
- Add known error types to Peddler::Errors.

### Fixed

- Don't camelise symbol keys with capital letters.
- Parse XML reports.

## [1.4.1] - 2016-09-03

### Changed

- Make Errors::Builder thread-safe.

### Fixed

- Support pallet lists in the FullfillmentInboundShipment/PutTransportContent
  operation.

## [1.4.0] - 2016-08-15

### Added

- Add GetPackageTrackingDetails operation to the FulfillmentOutboundShipment
  client.
- Add GetMyFeesEstimate operation to the Products client.

### Changed

- Raise error if one of two required keywords is not specified when listing
  orders.
- Add optional handler that makes API errors more expressive. This will become
  default next major version bump.

### Removed

- Remove obsolete Webstore API, Cart Information, and Customer Information
  APIs.

### Fixed

- Parse summaries of non-English flat files.
- Fix Excon error handling after breaking changes in its 0.50.0 release.

## [1.3.0] - 2016-01-21

### Added

- Add Merchant Fulfillment API.

## [1.2.0] - 2016-01-06

### Added

- Rewrite VCR Matcher.

## [1.1.1] - 2015-12-27

### Changed

- Encode with CP-1252 in place of ISO-8859-1.
- Encode with Windows-31J in place of Shift_JIS.

### Fixed

- Fix CancelFeedSubmissions operation in the Feeds client.

## [1.1.0] - 2015-10-28

### Added

- Add GetLowestPricedOffersForSKU and GetLowestPricedOffersForASIN operations
  to the Products client.

## [1.0.2] - 2015-10-25

### Fixed

- Improve XML parser: not all top nodes end with "Result"

## [1.0.1] - 2015-09-25

### Added

- Extract VCR matcher to a reusable file

### Fixed

- Improve XML parser: handle responses with no Content-Type header

## 1.0.0 - 2015-08-25

[Unreleased]: https://github.com/hakanensari/peddler/compare/v5.3.0...HEAD
[5.3.0]: https://github.com/hakanensari/peddler/compare/v5.2.0...v5.3.0
[5.2.0]: https://github.com/hakanensari/peddler/compare/v5.1.0...v5.2.0
[5.1.0]: https://github.com/hakanensari/peddler/compare/v5.0.0...v5.1.0
[5.0.0]: https://github.com/hakanensari/peddler/compare/v4.9.0...v5.0.0
[4.9.0]: https://github.com/hakanensari/peddler/compare/v4.8.0...v4.9.0
[4.8.0]: https://github.com/hakanensari/peddler/compare/v4.7.0...v4.8.0
[4.7.0]: https://github.com/hakanensari/peddler/compare/v4.6.1...v4.7.0
[4.6.1]: https://github.com/hakanensari/peddler/compare/v4.6.0...v4.6.1
[4.6.0]: https://github.com/hakanensari/peddler/compare/v4.5.0...v4.6.0
[4.5.0]: https://github.com/hakanensari/peddler/compare/v4.4.0...v4.5.0
[4.4.0]: https://github.com/hakanensari/peddler/compare/v4.3.1...v4.4.0
[4.3.1]: https://github.com/hakanensari/peddler/compare/v4.3.0...v4.3.1
[4.3.0]: https://github.com/hakanensari/peddler/compare/v4.2.0...v4.3.0
[4.2.0]: https://github.com/hakanensari/peddler/compare/v4.1.1...v4.2.0
[4.1.1]: https://github.com/hakanensari/peddler/compare/v4.0.1...v4.1.1
[4.0.1]: https://github.com/hakanensari/peddler/compare/v4.0.0...v4.0.1
[4.0.0]: https://github.com/hakanensari/peddler/compare/v3.0.0...v4.0.0
[3.0.0]: https://github.com/hakanensari/peddler/compare/v2.4.5...v3.0.0
[2.4.4]: https://github.com/hakanensari/peddler/compare/v2.4.4...v2.4.5
[2.4.4]: https://github.com/hakanensari/peddler/compare/v2.4.3...v2.4.4
[2.4.3]: https://github.com/hakanensari/peddler/compare/v2.4.2...v2.4.3
[2.4.2]: https://github.com/hakanensari/peddler/compare/v2.4.1...v2.4.2
[2.4.1]: https://github.com/hakanensari/peddler/compare/v2.4.0...v2.4.1
[2.4.0]: https://github.com/hakanensari/peddler/compare/v2.3.0...v2.4.0
[2.3.0]: https://github.com/hakanensari/peddler/compare/v2.2.0...v2.3.0
[2.2.0]: https://github.com/hakanensari/peddler/compare/v2.1.1...v2.2.0
[2.1.1]: https://github.com/hakanensari/peddler/compare/v2.1.0...v2.1.1
[2.1.0]: https://github.com/hakanensari/peddler/compare/v2.0.4...v2.1.0
[2.0.4]: https://github.com/hakanensari/peddler/compare/v2.0.3...v2.0.4
[2.0.3]: https://github.com/hakanensari/peddler/compare/v2.0.2...v2.0.3
[2.0.2]: https://github.com/hakanensari/peddler/compare/v2.0.1...v2.0.2
[2.0.1]: https://github.com/hakanensari/peddler/compare/v2.0.0...v2.0.1
[2.0.0]: https://github.com/hakanensari/peddler/compare/v1.6.7...v2.0.0
[1.6.7]: https://github.com/hakanensari/peddler/compare/v1.6.6...v1.6.7
[1.6.6]: https://github.com/hakanensari/peddler/compare/v1.6.5...v1.6.6
[1.6.5]: https://github.com/hakanensari/peddler/compare/v1.6.4...v1.6.5
[1.6.4]: https://github.com/hakanensari/peddler/compare/v1.6.3...v1.6.4
[1.6.3]: https://github.com/hakanensari/peddler/compare/v1.6.2...v1.6.3
[1.6.2]: https://github.com/hakanensari/peddler/compare/v1.6.1...v1.6.2
[1.6.1]: https://github.com/hakanensari/peddler/compare/v1.6.0...v1.6.1
[1.6.0]: https://github.com/hakanensari/peddler/compare/v1.5.0...v1.6.0
[1.5.0]: https://github.com/hakanensari/peddler/compare/v1.4.1...v1.5.0
[1.4.1]: https://github.com/hakanensari/peddler/compare/v1.4.0...v1.4.1
[1.4.0]: https://github.com/hakanensari/peddler/compare/v1.3.0...v1.4.0
[1.3.0]: https://github.com/hakanensari/peddler/compare/v1.2.0...v1.3.0
[1.2.0]: https://github.com/hakanensari/peddler/compare/v1.1.1...v1.2.0
[1.1.1]: https://github.com/hakanensari/peddler/compare/v1.1.0...v1.1.1
[1.1.0]: https://github.com/hakanensari/peddler/compare/v1.0.2...v1.1.0
[1.0.2]: https://github.com/hakanensari/peddler/compare/v1.0.1...v1.0.2
[1.0.1]: https://github.com/hakanensari/peddler/compare/v1.0.0...v1.0.1
