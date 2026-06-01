# Writing efficient SP-API code

## Cut call volume with notifications

Subscribe once and persist; do not recreate subscriptions on every boot. Call `get_subscription` before `create_subscription` to avoid duplicates. Prefer EventBridge over SQS for cross-region or multi-account setups, and subscribe to the latest payload version.

- `ORDER_CHANGE` instead of polling `get_orders`
- `LISTINGS_ITEM_STATUS_CHANGE` instead of polling listings
- `FEED_PROCESSING_FINISHED` instead of polling feed status
- `REPORT_PROCESSING_FINISHED` instead of polling report status
- `FBA_INVENTORY_AVAILABILITY_CHANGES` instead of polling FBA inventory
- `TRANSACTION_UPDATE` instead of polling `list_transactions`
- `PRICING_HEALTH` for competitive pricing alerts

## Batch and list endpoints

Avoid loops of single-item GETs when a list endpoint exists. Request only the fields you need via `includedData` (Catalog, Orders).

- `search_catalog_items` over `get_catalog_item`
- `search_orders` with `includedData` over follow-up calls for buyer, recipient, or financial data
- `list_inbound_plans` over `get_inbound_plan` (Fulfillment Inbound)
- `list_inbound_shipments` over `get_inbound_shipment` (AWD)
- `patch_listings_item` for partial updates over full `put_listings_item`
- `get_eligible_shipping_services` for multi-carrier rate shopping in one call
- `delivery_offers` for batch delivery lookups (Fulfillment Outbound)
- `create_restricted_data_token` takes multiple `restrictedResources` paths; batch them

## Cache slow-changing data

- Access tokens and RDTs: 1h validity, cache and reuse (see peddler's README)
- Marketplace participations (`get_marketplace_participations`): change rarely, cache aggressively
- Catalog items, product type definitions, listings restrictions: infrequent per ASIN or marketplace
- Shipping rate estimates: short TTL keyed on package dimensions
- Competitive pricing: short TTL, avoid per-request lookups

## Prefer the latest API version

Peddler exposes `Peddler.<api>_<version>` (pinned) and `Peddler.<api>` (latest). Use the latest unless you have a reason to pin.

- Orders: `Peddler.orders` (v2026-01-01) over `Peddler.orders_v0`; discussion [#253](https://github.com/amzn/selling-partner-api-samples/discussions/253) maps the attributes
- Finances: `Peddler.finances` (v2024-06-19) over v0, for real-time data with no statement-period wait
- Shipping: v2 for multi-carrier rate shopping
- Tracking: `packageNumber` with `get_package_tracking_details`, not the deprecated `amazonFulfillmentTrackingNumber`

## Use reports for bulk history

Request a report rather than paginating live endpoints, and pair it with `REPORT_PROCESSING_FINISHED` notifications instead of polling status.

- All Orders report (`GET_FLAT_FILE_ALL_ORDERS_DATA_BY_ORDER_DATE_GENERAL`) over paginated `get_orders`
- Merchant Listings report for bulk listing data
- FBA Inventory report for bulk inventory

## Test in sandbox first

Chain `.sandbox` on the constructor. Operations that do not support sandbox raise `Peddler::API::CannotSandbox`; `must_sandbox!` guards keep fixture generation in sandbox.

## API quirks

- Fulfillment Outbound (MCF): max 100 line items and 250 units per order
- Fulfillment Inbound: up to 1500 SKUs per plan; batch into fewer plans
- Easy Ship: not all marketplaces support it, so check first
- Data Kiosk: schedule queries off-peak for faster processing
