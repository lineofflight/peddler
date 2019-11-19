# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]
### Added
- Add Easy Ship API
- Add Shipment Invoicing API

### Removed
- Remove China. It is no longer supported starting 1st October 2019.

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

[Unreleased]: https://github.com/hakanensari/peddler/compare/v2.2.0...HEAD
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
