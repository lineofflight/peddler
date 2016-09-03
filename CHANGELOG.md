# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]
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

[Unreleased]: https://github.com/hakanensari/peddler/compare/v0.3.0...HEAD
[1.3.0]: https://github.com/hakanensari/peddler/compare/v1.2.0...v1.3.0
[1.2.0]: https://github.com/hakanensari/peddler/compare/v1.1.1...v1.2.0
[1.1.1]: https://github.com/hakanensari/peddler/compare/v1.1.0...v1.1.1
[1.1.0]: https://github.com/hakanensari/peddler/compare/v1.0.2...v1.1.0
[1.0.2]: https://github.com/hakanensari/peddler/compare/v1.0.1...v1.0.2
[1.0.1]: https://github.com/hakanensari/peddler/compare/v1.0.0...v1.0.1
