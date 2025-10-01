# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/apis/amazon_warehousing_and_distribution_2024_05_09"
require "peddler/apis/aplus_content_2020_11_01"
require "peddler/apis/application_integrations_2024_04_01"
require "peddler/apis/application_management_2023_11_30"
require "peddler/apis/catalog_items_2020_12_01"
require "peddler/apis/catalog_items_2022_04_01"
require "peddler/apis/catalog_items_v0"
require "peddler/apis/customer_feedback_2024_06_01"
require "peddler/apis/data_kiosk_2023_11_15"
require "peddler/apis/easy_ship_2022_03_23"
require "peddler/apis/external_fulfillment_inventory_2024_09_11"
require "peddler/apis/external_fulfillment_returns_2024_09_11"
require "peddler/apis/external_fulfillment_shipments_2024_09_11"
require "peddler/apis/fba_inbound_eligibility_v1"
require "peddler/apis/fba_inventory_v1"
require "peddler/apis/feeds_2021_06_30"
require "peddler/apis/finances_2024_06_19"
require "peddler/apis/finances_v0"
require "peddler/apis/fulfillment_inbound_2024_03_20"
require "peddler/apis/fulfillment_inbound_v0"
require "peddler/apis/fulfillment_outbound_2020_07_01"
require "peddler/apis/invoices_2024_06_19"
require "peddler/apis/listings_items_2020_09_01"
require "peddler/apis/listings_items_2021_08_01"
require "peddler/apis/listings_restrictions_2021_08_01"
require "peddler/apis/merchant_fulfillment_v0"
require "peddler/apis/messaging_v1"
require "peddler/apis/notifications_v1"
require "peddler/apis/orders_v0"
require "peddler/apis/product_fees_v0"
require "peddler/apis/product_pricing_2022_05_01"
require "peddler/apis/product_pricing_v0"
require "peddler/apis/product_type_definitions_2020_09_01"
require "peddler/apis/replenishment_2022_11_07"
require "peddler/apis/reports_2021_06_30"
require "peddler/apis/sales_v1"
require "peddler/apis/seller_wallet_2024_03_01"
require "peddler/apis/sellers_v1"
require "peddler/apis/services_v1"
require "peddler/apis/shipment_invoicing_v0"
require "peddler/apis/shipping_v1"
require "peddler/apis/shipping_v2"
require "peddler/apis/solicitations_v1"
require "peddler/apis/supply_sources_2020_07_01"
require "peddler/apis/tokens_2021_03_01"
require "peddler/apis/transfers_2024_06_01"
require "peddler/apis/uploads_2020_11_01"
require "peddler/apis/vehicles_2024_11_01"
require "peddler/apis/vendor_direct_fulfillment_inventory_v1"
require "peddler/apis/vendor_direct_fulfillment_orders_2021_12_28"
require "peddler/apis/vendor_direct_fulfillment_orders_v1"
require "peddler/apis/vendor_direct_fulfillment_payments_v1"
require "peddler/apis/vendor_direct_fulfillment_sandbox_test_data_2021_10_28"
require "peddler/apis/vendor_direct_fulfillment_shipping_2021_12_28"
require "peddler/apis/vendor_direct_fulfillment_shipping_v1"
require "peddler/apis/vendor_direct_fulfillment_transactions_2021_12_28"
require "peddler/apis/vendor_direct_fulfillment_transactions_v1"
require "peddler/apis/vendor_invoices_v1"
require "peddler/apis/vendor_orders_v1"
require "peddler/apis/vendor_shipments_v1"
require "peddler/apis/vendor_transaction_status_v1"
require "peddler/token"

module Peddler
  class << self
    alias_method :amazon_warehousing_and_distribution, :amazon_warehousing_and_distribution_2024_05_09
    alias_method :aplus_content, :aplus_content_2020_11_01
    alias_method :application_integrations, :application_integrations_2024_04_01
    alias_method :application_management, :application_management_2023_11_30
    alias_method :catalog_items, :catalog_items_2022_04_01
    alias_method :customer_feedback, :customer_feedback_2024_06_01
    alias_method :data_kiosk, :data_kiosk_2023_11_15
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
