# frozen_string_literal: true

# This file is generated. Do not edit.

require "zeitwerk"
require "peddler/inflector"

loader = Zeitwerk::Loader.for_gem
loader.inflector = Peddler::Inflector.new(__FILE__)
if File.exist?("#{__dir__}/generator.rb")
  loader.ignore("#{__dir__}/generator.rb")
  loader.ignore("#{__dir__}/generator")
end
# The native layer loads eagerly below. Compiled extensions ship in lib/peddler/<ruby minor>/.
loader.ignore("#{__dir__}/peddler/native")
loader.ignore("#{__dir__}/peddler/[0-9]*")
# The WebMock adapter loads only when an application requires it.
webmock = "#{__dir__}/peddler/webmock.rb"
loader.ignore(webmock)
loader.setup
Peddler::LOADER = loader

require "peddler/native/boot"
# What an application calls loads now, so that a Ractor finds it loaded: on Ruby 3.3 only the main Ractor loads code.
# The typed models load on first use, or all at once with Peddler.eager_load!.
(Dir["#{__dir__}/peddler/{*,lwa/*}.rb"] - [webmock]).sort.each { |file| require file }

module Peddler
  private_constant :LOADER

  class << self
    # Builds a client: short for {Peddler::Client#initialize Peddler::Client.new}, with the same arguments
    #
    # @example
    #   client = Peddler.new(region: "us-east-1", access_token: token)
    # @return [Peddler::Client]
    def new(...)
      Client.new(...)
    end

    # Loads every typed model now, which takes about a second
    #
    # Ruby 3.3 loads code in the main Ractor only. Call this there before another Ractor parses a response, a
    # notification, a report, a feed or a Data Kiosk document. From Ruby 3.4 a Ractor loads a model on first use.
    #
    # @return [void]
    def eager_load!
      LOADER.eager_load
    end
  end

  module APIs
    # Each API's typed model lookup, by the API part of a native operation key. Shareable, so that any Ractor can
    # read it.
    PARSERS = Ractor.make_shareable({
      "amazon_warehousing_and_distribution_2024_05_09" => -> { AmazonWarehousingAndDistribution20240509::PARSERS },
      "aplus_content_2020_11_01" => -> { AplusContent20201101::PARSERS },
      "application_integrations_2024_04_01" => -> { ApplicationIntegrations20240401::PARSERS },
      "application_management_2023_11_30" => -> { ApplicationManagement20231130::PARSERS },
      "catalog_items_v0" => -> { CatalogItemsV0::PARSERS },
      "catalog_items_2020_12_01" => -> { CatalogItems20201201::PARSERS },
      "catalog_items_2022_04_01" => -> { CatalogItems20220401::PARSERS },
      "customer_feedback_2024_06_01" => -> { CustomerFeedback20240601::PARSERS },
      "data_kiosk_2023_11_15" => -> { DataKiosk20231115::PARSERS },
      "delivery_by_amazon_2022_07_01" => -> { DeliveryByAmazon20220701::PARSERS },
      "easy_ship_2022_03_23" => -> { EasyShip20220323::PARSERS },
      "external_fulfillment_inventory_2024_09_11" => -> { ExternalFulfillmentInventory20240911::PARSERS },
      "external_fulfillment_location_2026_07_30" => -> { ExternalFulfillmentLocation20260730::PARSERS },
      "external_fulfillment_returns_2024_09_11" => -> { ExternalFulfillmentReturns20240911::PARSERS },
      "external_fulfillment_shipments_2024_09_11" => -> { ExternalFulfillmentShipments20240911::PARSERS },
      "fba_inbound_eligibility_v1" => -> { FBAInboundEligibilityV1::PARSERS },
      "fba_inventory_v1" => -> { FBAInventoryV1::PARSERS },
      "feeds_2021_06_30" => -> { Feeds20210630::PARSERS },
      "finance_remittance_2026_03_17" => -> { FinanceRemittance20260317::PARSERS },
      "finances_v0" => -> { FinancesV0::PARSERS },
      "finances_2024_06_19" => -> { Finances20240619::PARSERS },
      "finances_invoices_2026_06_25" => -> { FinancesInvoices20260625::PARSERS },
      "fulfillment_inbound_v0" => -> { FulfillmentInboundV0::PARSERS },
      "fulfillment_inbound_2024_03_20" => -> { FulfillmentInbound20240320::PARSERS },
      "fulfillment_outbound_2020_07_01" => -> { FulfillmentOutbound20200701::PARSERS },
      "fulfillment_outbound_2026_07_04" => -> { FulfillmentOutbound20260704::PARSERS },
      "invoices_2024_06_19" => -> { Invoices20240619::PARSERS },
      "listings_items_2020_09_01" => -> { ListingsItems20200901::PARSERS },
      "listings_items_2021_08_01" => -> { ListingsItems20210801::PARSERS },
      "listings_restrictions_2021_08_01" => -> { ListingsRestrictions20210801::PARSERS },
      "merchant_fulfillment_v0" => -> { MerchantFulfillmentV0::PARSERS },
      "messaging_v1" => -> { MessagingV1::PARSERS },
      "notifications_v1" => -> { NotificationsV1::PARSERS },
      "orders_v0" => -> { OrdersV0::PARSERS },
      "orders_2026_01_01" => -> { Orders20260101::PARSERS },
      "product_fees_v0" => -> { ProductFeesV0::PARSERS },
      "product_pricing_v0" => -> { ProductPricingV0::PARSERS },
      "product_pricing_2022_05_01" => -> { ProductPricing20220501::PARSERS },
      "product_type_definitions_2020_09_01" => -> { ProductTypeDefinitions20200901::PARSERS },
      "promotions_2025_12_01" => -> { Promotions20251201::PARSERS },
      "replenishment_2022_11_07" => -> { Replenishment20221107::PARSERS },
      "reports_2021_06_30" => -> { Reports20210630::PARSERS },
      "sales_v1" => -> { SalesV1::PARSERS },
      "seller_wallet_2024_03_01" => -> { SellerWallet20240301::PARSERS },
      "sellers_v1" => -> { SellersV1::PARSERS },
      "services_v1" => -> { ServicesV1::PARSERS },
      "shipment_invoicing_v0" => -> { ShipmentInvoicingV0::PARSERS },
      "shipping_v1" => -> { ShippingV1::PARSERS },
      "shipping_v2" => -> { ShippingV2::PARSERS },
      "solicitations_v1" => -> { SolicitationsV1::PARSERS },
      "supply_sources_2020_07_01" => -> { SupplySources20200701::PARSERS },
      "support_2025_02_01" => -> { Support20250201::PARSERS },
      "tokens_2021_03_01" => -> { Tokens20210301::PARSERS },
      "tracking_2026_01_30" => -> { Tracking20260130::PARSERS },
      "transfers_2024_06_01" => -> { Transfers20240601::PARSERS },
      "uploads_2020_11_01" => -> { Uploads20201101::PARSERS },
      "vehicles_2024_11_01" => -> { Vehicles20241101::PARSERS },
      "vendor_direct_fulfillment_inventory_v1" => -> { VendorDirectFulfillmentInventoryV1::PARSERS },
      "vendor_direct_fulfillment_orders_v1" => -> { VendorDirectFulfillmentOrdersV1::PARSERS },
      "vendor_direct_fulfillment_orders_2021_12_28" => -> { VendorDirectFulfillmentOrders20211228::PARSERS },
      "vendor_direct_fulfillment_payments_v1" => -> { VendorDirectFulfillmentPaymentsV1::PARSERS },
      "vendor_direct_fulfillment_sandbox_test_data_2021_10_28" => -> { VendorDirectFulfillmentSandboxTestData20211028::PARSERS },
      "vendor_direct_fulfillment_shipping_v1" => -> { VendorDirectFulfillmentShippingV1::PARSERS },
      "vendor_direct_fulfillment_shipping_2021_12_28" => -> { VendorDirectFulfillmentShipping20211228::PARSERS },
      "vendor_direct_fulfillment_transactions_v1" => -> { VendorDirectFulfillmentTransactionsV1::PARSERS },
      "vendor_direct_fulfillment_transactions_2021_12_28" => -> { VendorDirectFulfillmentTransactions20211228::PARSERS },
      "vendor_invoices_v1" => -> { VendorInvoicesV1::PARSERS },
      "vendor_orders_v1" => -> { VendorOrdersV1::PARSERS },
      "vendor_shipments_v1" => -> { VendorShipmentsV1::PARSERS },
      "vendor_transaction_status_v1" => -> { VendorTransactionStatusV1::PARSERS },
    })
  end
end
