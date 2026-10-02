# Full operation fixtures

`full_cases.json` contains 16 synthetic request/response cases with manually
checked paths, scalar values, query pairs and headers from the pinned API specs.
Rust dispatch and generated native Ruby methods replay the same cases against
loopback HTTP servers. These contain dummy identifiers and no credentials.

`create_order_200.json` is exactly the public `createOrder` 200 application/json
example from `models/fulfillment-outbound-api-model/fulfillmentOutbound_2026-07-04.json`
at Amazon revision `3677bb9d96f4450e6843f1f8207005e925d5c867`. The 202 decoder case
uses a minimal synthetic response. Neither file is an exported VCR interaction.
