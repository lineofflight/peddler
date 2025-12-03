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
loader.setup

module Peddler
  class << self
    def amazon_warehousing_and_distribution_2024_05_09 = APIs::AmazonWarehousingAndDistribution20240509
    def aplus_content_2020_11_01 = APIs::AplusContent20201101
    def application_integrations_2024_04_01 = APIs::ApplicationIntegrations20240401
    def application_management_2023_11_30 = APIs::ApplicationManagement20231130
    def catalog_items_v0 = APIs::CatalogItemsV0
    def catalog_items_2020_12_01 = APIs::CatalogItems20201201
    def catalog_items_2022_04_01 = APIs::CatalogItems20220401
    def customer_feedback_2024_06_01 = APIs::CustomerFeedback20240601
    def data_kiosk_2023_11_15 = APIs::DataKiosk20231115
    def delivery_by_amazon_2022_07_01 = APIs::DeliveryByAmazon20220701
    def easy_ship_2022_03_23 = APIs::EasyShip20220323
    def external_fulfillment_inventory_2024_09_11 = APIs::ExternalFulfillmentInventory20240911
    def external_fulfillment_returns_2024_09_11 = APIs::ExternalFulfillmentReturns20240911
    def external_fulfillment_shipments_2024_09_11 = APIs::ExternalFulfillmentShipments20240911
    def fba_inbound_eligibility_v1 = APIs::FBAInboundEligibilityV1
    def fba_inventory_v1 = APIs::FBAInventoryV1
    def feeds_2021_06_30 = APIs::Feeds20210630
    def finances_v0 = APIs::FinancesV0
    def finances_2024_06_19 = APIs::Finances20240619
    def fulfillment_inbound_v0 = APIs::FulfillmentInboundV0
    def fulfillment_inbound_2024_03_20 = APIs::FulfillmentInbound20240320
    def fulfillment_outbound_2020_07_01 = APIs::FulfillmentOutbound20200701
    def invoices_2024_06_19 = APIs::Invoices20240619
    def listings_items_2020_09_01 = APIs::ListingsItems20200901
    def listings_items_2021_08_01 = APIs::ListingsItems20210801
    def listings_restrictions_2021_08_01 = APIs::ListingsRestrictions20210801
    def merchant_fulfillment_v0 = APIs::MerchantFulfillmentV0
    def messaging_v1 = APIs::MessagingV1
    def notifications_v1 = APIs::NotificationsV1
    def orders_v0 = APIs::OrdersV0
    def product_fees_v0 = APIs::ProductFeesV0
    def product_pricing_v0 = APIs::ProductPricingV0
    def product_pricing_2022_05_01 = APIs::ProductPricing20220501
    def product_type_definitions_2020_09_01 = APIs::ProductTypeDefinitions20200901
    def replenishment_2022_11_07 = APIs::Replenishment20221107
    def reports_2021_06_30 = APIs::Reports20210630
    def sales_v1 = APIs::SalesV1
    def seller_wallet_2024_03_01 = APIs::SellerWallet20240301
    def sellers_v1 = APIs::SellersV1
    def services_v1 = APIs::ServicesV1
    def shipment_invoicing_v0 = APIs::ShipmentInvoicingV0
    def shipping_v1 = APIs::ShippingV1
    def shipping_v2 = APIs::ShippingV2
    def solicitations_v1 = APIs::SolicitationsV1
    def supply_sources_2020_07_01 = APIs::SupplySources20200701
    def tokens_2021_03_01 = APIs::Tokens20210301
    def transfers_2024_06_01 = APIs::Transfers20240601
    def uploads_2020_11_01 = APIs::Uploads20201101
    def vehicles_2024_11_01 = APIs::Vehicles20241101
    def vendor_direct_fulfillment_inventory_v1 = APIs::VendorDirectFulfillmentInventoryV1
    def vendor_direct_fulfillment_orders_v1 = APIs::VendorDirectFulfillmentOrdersV1
    def vendor_direct_fulfillment_orders_2021_12_28 = APIs::VendorDirectFulfillmentOrders20211228
    def vendor_direct_fulfillment_payments_v1 = APIs::VendorDirectFulfillmentPaymentsV1
    def vendor_direct_fulfillment_sandbox_test_data_2021_10_28 = APIs::VendorDirectFulfillmentSandboxTestData20211028
    def vendor_direct_fulfillment_shipping_v1 = APIs::VendorDirectFulfillmentShippingV1
    def vendor_direct_fulfillment_shipping_2021_12_28 = APIs::VendorDirectFulfillmentShipping20211228
    def vendor_direct_fulfillment_transactions_v1 = APIs::VendorDirectFulfillmentTransactionsV1
    def vendor_direct_fulfillment_transactions_2021_12_28 = APIs::VendorDirectFulfillmentTransactions20211228
    def vendor_invoices_v1 = APIs::VendorInvoicesV1
    def vendor_orders_v1 = APIs::VendorOrdersV1
    def vendor_shipments_v1 = APIs::VendorShipmentsV1
    def vendor_transaction_status_v1 = APIs::VendorTransactionStatusV1

    alias_method :amazon_warehousing_and_distribution, :amazon_warehousing_and_distribution_2024_05_09
    alias_method :aplus_content, :aplus_content_2020_11_01
    alias_method :application_integrations, :application_integrations_2024_04_01
    alias_method :application_management, :application_management_2023_11_30
    alias_method :catalog_items, :catalog_items_2022_04_01
    alias_method :customer_feedback, :customer_feedback_2024_06_01
    alias_method :data_kiosk, :data_kiosk_2023_11_15
    alias_method :delivery_by_amazon, :delivery_by_amazon_2022_07_01
    alias_method :easy_ship, :easy_ship_2022_03_23
    alias_method :external_fulfillment_inventory, :external_fulfillment_inventory_2024_09_11
    alias_method :external_fulfillment_returns, :external_fulfillment_returns_2024_09_11
    alias_method :external_fulfillment_shipments, :external_fulfillment_shipments_2024_09_11
    alias_method :fba_inbound_eligibility, :fba_inbound_eligibility_v1
    alias_method :fba_inventory, :fba_inventory_v1
    alias_method :feeds, :feeds_2021_06_30
    alias_method :finances, :finances_2024_06_19
    alias_method :fulfillment_inbound, :fulfillment_inbound_2024_03_20
    alias_method :fulfillment_outbound, :fulfillment_outbound_2020_07_01
    alias_method :invoices, :invoices_2024_06_19
    alias_method :listings_items, :listings_items_2021_08_01
    alias_method :listings_restrictions, :listings_restrictions_2021_08_01
    alias_method :merchant_fulfillment, :merchant_fulfillment_v0
    alias_method :messaging, :messaging_v1
    alias_method :notifications, :notifications_v1
    alias_method :orders, :orders_v0
    alias_method :product_fees, :product_fees_v0
    alias_method :product_pricing, :product_pricing_2022_05_01
    alias_method :product_type_definitions, :product_type_definitions_2020_09_01
    alias_method :replenishment, :replenishment_2022_11_07
    alias_method :reports, :reports_2021_06_30
    alias_method :sales, :sales_v1
    alias_method :seller_wallet, :seller_wallet_2024_03_01
    alias_method :sellers, :sellers_v1
    alias_method :services, :services_v1
    alias_method :shipment_invoicing, :shipment_invoicing_v0
    alias_method :shipping, :shipping_v2
    alias_method :solicitations, :solicitations_v1
    alias_method :supply_sources, :supply_sources_2020_07_01
    alias_method :tokens, :tokens_2021_03_01
    alias_method :transfers, :transfers_2024_06_01
    alias_method :uploads, :uploads_2020_11_01
    alias_method :vehicles, :vehicles_2024_11_01
    alias_method :vendor_direct_fulfillment_inventory, :vendor_direct_fulfillment_inventory_v1
    alias_method :vendor_direct_fulfillment_orders, :vendor_direct_fulfillment_orders_2021_12_28
    alias_method :vendor_direct_fulfillment_payments, :vendor_direct_fulfillment_payments_v1
    alias_method :vendor_direct_fulfillment_sandbox_test_data, :vendor_direct_fulfillment_sandbox_test_data_2021_10_28
    alias_method :vendor_direct_fulfillment_shipping, :vendor_direct_fulfillment_shipping_2021_12_28
    alias_method :vendor_direct_fulfillment_transactions, :vendor_direct_fulfillment_transactions_2021_12_28
    alias_method :vendor_invoices, :vendor_invoices_v1
    alias_method :vendor_orders, :vendor_orders_v1
    alias_method :vendor_shipments, :vendor_shipments_v1
    alias_method :vendor_transaction_status, :vendor_transaction_status_v1
  end
end
