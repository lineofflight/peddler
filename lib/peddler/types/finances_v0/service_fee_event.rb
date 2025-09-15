# frozen_string_literal: true

require "peddler/types/finances_v0/fee_component"

module Peddler
  module Types
    module FinancesV0
      # A service fee on the seller's account.
      ServiceFeeEvent = Structure.new do
        # @return [String] An Amazon-defined identifier for an order.
        attribute(:amazon_order_id, String, from: "AmazonOrderId")

        # @return [String] A short description of the service fee reason.
        attribute(:fee_reason, String, from: "FeeReason")

        # @return [Array<FeeComponent>] A list of fee components associated with the service fee.
        attribute(:fee_list, [FeeComponent], from: "FeeList")

        # @return [String] The seller SKU of the item. The seller SKU is qualified by the seller's seller ID, which is
        # included with every call to the Selling Partner API.
        attribute(:seller_sku, String, from: "SellerSKU")

        # @return [String] A unique identifier assigned by Amazon to products stored in and fulfilled from an Amazon
        # fulfillment center.
        attribute(:fn_sku, String, from: "FnSKU")

        # @return [String] A short description of the service fee event.
        attribute(:fee_description, String, from: "FeeDescription")

        # @return [String] The Amazon Standard Identification Number (ASIN) of the item.
        attribute(:asin, String, from: "ASIN")

        # @return [String] The name of the store where the event occurred.
        attribute(:store_name, String, from: "StoreName")
      end
    end
  end
end
