# Writing efficient SP-API code

These sections mirror the pillars Amazon's `sp_api_optimize` tool reviews (part of the [sp-api-dev-mcp](https://github.com/amzn/selling-partner-api-samples/tree/main/use-cases/sp-api-dev-mcp) sample), so a finding from that tool maps onto the guidance here. Several pillars peddler already handles; each note says what is automatic and what is yours.

## Scheduling

Spread non-urgent work instead of bursting it. Let notifications drive work rather than fixed-interval polling (see Notifications), stagger cron jobs so they do not collide against per-operation rate limits, and run bulk pulls (reports, Data Kiosk) off-peak for faster processing.

## Error handling

peddler raises a typed `Peddler::Errors::*` on every 4xx/5xx (`QuotaExceeded`, `InvalidInput`, `NotFound`, `AccessDenied`, `Unauthorized`, …); rescue the specific class rather than inspecting status codes by hand. Treat 4xx as permanent: fix the request (bad input, missing role or scope) instead of retrying it. Amazon's [4xx handling guide](https://github.com/amzn/selling-partner-api-samples/discussions/195) maps the common causes; [#186](https://github.com/amzn/selling-partner-api-samples/discussions/186) covers error handling generally.

## Rate limiting

peddler retries `429` and transient `5xx` with rate-limit-aware exponential backoff and jitter, but only when you opt in with `retries:` on the factory (default `0`). Generated operations already carry Amazon's documented per-operation `rate_limit`, so the backoff paces itself and you never compute delays. Set `retries:`; never hand-roll `sleep` or throttle loops.

```ruby
Peddler.orders(aws_region, access_token, retries: 3)
```

## Batching

Avoid loops of single-item GETs when a list endpoint exists. Request only the fields you need via `includedData` (Catalog, Orders).

- `search_catalog_items` over `get_catalog_item`
- `search_orders` with `includedData` over follow-up calls for buyer, recipient, or financial data
- `list_inbound_plans` over `get_inbound_plan` (Fulfillment Inbound)
- `list_inbound_shipments` over `get_inbound_shipment` (AWD)
- `patch_listings_item` for partial updates over full `put_listings_item`
- `get_eligible_shipping_services` for multi-carrier rate shopping in one call
- `delivery_offers` for batch delivery lookups (Fulfillment Outbound)
- `create_restricted_data_token` takes multiple `restrictedResources` paths; batch them

## Pagination

Loop on the `nextToken`/pagination token the response returns; never bump page offsets by hand. `nextToken` does not re-apply filters, so keep paging until it is absent. Prefer a report over deep pagination for history (see Reports).

## Notifications

Subscribe once and persist; do not recreate subscriptions on every boot. Call `get_subscription` before `create_subscription` to avoid duplicates. Prefer EventBridge over SQS for cross-region or multi-account setups, and subscribe to the latest payload version. See [#187](https://github.com/amzn/selling-partner-api-samples/discussions/187) on cutting call volume.

- `ORDER_CHANGE` instead of polling `get_orders`
- `LISTINGS_ITEM_STATUS_CHANGE` instead of polling listings
- `FEED_PROCESSING_FINISHED` instead of polling feed status
- `REPORT_PROCESSING_FINISHED` instead of polling report status
- `FBA_INVENTORY_AVAILABILITY_CHANGES` instead of polling FBA inventory
- `TRANSACTION_UPDATE` instead of polling `list_transactions`
- `PRICING_HEALTH` for competitive pricing alerts

## Reports

Request a report rather than paginating live endpoints, and pair it with `REPORT_PROCESSING_FINISHED` notifications instead of polling status.

- All Orders report (`GET_FLAT_FILE_ALL_ORDERS_DATA_BY_ORDER_DATE_GENERAL`) over paginated `get_orders`
- Merchant Listings report for bulk listing data
- FBA Inventory report for bulk inventory

## Caching

- Access tokens and RDTs: 1h validity, cache and reuse (see peddler's README)
- Marketplace participations (`get_marketplace_participations`): change rarely, cache aggressively
- Catalog items, product type definitions, listings restrictions: infrequent per ASIN or marketplace
- Shipping rate estimates: short TTL keyed on package dimensions
- Competitive pricing: short TTL, avoid per-request lookups

## API modernness

Peddler exposes `Peddler.<api>_<version>` (pinned) and `Peddler.<api>` (latest). Use the latest unless you have a reason to pin.

- Orders: `Peddler.orders` (v2026-01-01) over `Peddler.orders_v0`; discussion [#253](https://github.com/amzn/selling-partner-api-samples/discussions/253) maps the attributes
- Finances: `Peddler.finances` (v2024-06-19) over v0, for real-time data with no statement-period wait
- Shipping: v2 for multi-carrier rate shopping
- Tracking: `packageNumber` with `get_package_tracking_details`, not the deprecated `amazonFulfillmentTrackingNumber`

## Sandbox

Chain `.sandbox` on the constructor. Operations that do not support sandbox raise `Peddler::API::CannotSandbox`; `must_sandbox!` guards keep fixture generation in sandbox.

## API quirks

- Fulfillment Outbound (MCF): max 100 line items and 250 units per order
- Fulfillment Inbound: up to 1500 SKUs per plan; batch into fewer plans
- Easy Ship: not all marketplaces support it, so check first
- Data Kiosk: schedule queries off-peak for faster processing
- Orders: data is available ~2 minutes after an order is created or updated, so re-poll rather than trusting the first empty result
