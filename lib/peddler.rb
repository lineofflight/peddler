# frozen_string_literal: true

require "peddler/api/amazon_warehousing_and_distribution_2024_05_09"
require "peddler/api/aplus_content_2020_11_01"
require "peddler/api/application_management_2023_11_30"
require "peddler/api/catalog_items_v0"
require "peddler/api/catalog_items_2020_12_01"
require "peddler/api/catalog_items_2022_04_01"
require "peddler/api/data_kiosk_2023_11_15"
require "peddler/api/easy_ship_2022_03_23"
require "peddler/api/fba_inbound_eligibility_v1"
require "peddler/api/fba_inventory_v1"
require "peddler/api/feeds_2021_06_30"
require "peddler/api/finances_v0"
require "peddler/api/fulfillment_inbound_v0"
require "peddler/api/fulfillment_inbound_2024_03_20"
require "peddler/api/fulfillment_outbound_2020_07_01"
require "peddler/api/listings_items_2020_09_01"
require "peddler/api/listings_items_2021_08_01"
require "peddler/api/listings_restrictions_2021_08_01"
require "peddler/api/merchant_fulfillment_v0"
require "peddler/api/messaging_v1"
require "peddler/api/notifications_v1"
require "peddler/api/orders_v0"
require "peddler/api/product_fees_v0"
require "peddler/api/product_pricing_v0"
require "peddler/api/product_pricing_2022_05_01"
require "peddler/api/product_type_definitions_2020_09_01"
require "peddler/api/replenishment_2022_11_07"
require "peddler/api/reports_2021_06_30"
require "peddler/api/sales_v1"
require "peddler/api/sellers_v1"
require "peddler/api/services_v1"
require "peddler/api/shipment_invoicing_v0"
require "peddler/api/shipping_v1"
require "peddler/api/shipping_v2"
require "peddler/api/solicitations_v1"
require "peddler/api/supply_sources_2020_07_01"
require "peddler/api/tokens_2021_03_01"
require "peddler/api/uploads_2020_11_01"
require "peddler/api/vendor_direct_fulfillment_inventory_v1"
require "peddler/api/vendor_direct_fulfillment_orders_v1"
require "peddler/api/vendor_direct_fulfillment_orders_2021_12_28"
require "peddler/api/vendor_direct_fulfillment_payments_v1"
require "peddler/api/vendor_direct_fulfillment_sandbox_test_data_2021_10_28"
require "peddler/api/vendor_direct_fulfillment_shipping_v1"
require "peddler/api/vendor_direct_fulfillment_shipping_2021_12_28"
require "peddler/api/vendor_direct_fulfillment_transactions_v1"
require "peddler/api/vendor_direct_fulfillment_transactions_2021_12_28"
require "peddler/api/vendor_invoices_v1"
require "peddler/api/vendor_orders_v1"
require "peddler/api/vendor_shipments_v1"
require "peddler/api/vendor_transaction_status_v1"
require "peddler/marketplace"
require "peddler/token"

module Peddler
  class << self
    # Define convenience methods for instantiating the API classes
    Peddler::API.constants.each do |const_name|
      method_name = const_name.to_s
        .gsub("FBA", "Fba")
        .gsub(/([a-z\d])([A-Z])/, '\1_\2')
        .gsub(/(\d{4})(\d{2})(\d{2})/, '_\1_\2_\3')
        .downcase
      define_method(method_name) do |*args|
        Peddler::API.const_get(const_name).new(*args)
      end
    end
  end
end
