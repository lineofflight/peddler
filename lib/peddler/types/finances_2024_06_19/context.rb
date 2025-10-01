# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module Finances20240619
      # Additional Information about the item.
      Context = Structure.new do
        # @return [String]
        attribute(:context_type, String, from: "contextType")

        # @return [String] Amazon Standard Identification Number (ASIN) of the item.
        attribute?(:asin, String)

        # @return [String] Channel details of related transaction.
        attribute?(:channel, String)

        # @return [String] The deferral policy applied to the transaction.
        #
        # **Examples:** `B2B` (invoiced orders), `DD7` (delivery date policy)
        attribute?(:deferral_reason, String, from: "deferralReason")

        # @return [String] End time of the transaction.
        attribute?(:end_time, String, from: "endTime")

        # @return [String] Fulfillment network of the item.
        attribute?(:fulfillment_network, String, from: "fulfillmentNetwork")

        # @return [String] The release date of the transaction.
        attribute?(:maturity_date, String, from: "maturityDate")

        # @return [String] Order type of the transaction.
        attribute?(:order_type, String, from: "orderType")

        # @return [String] Date of payment made.
        attribute?(:payment_date, String, from: "paymentDate")

        # @return [String] Method of payment made.
        attribute?(:payment_method, String, from: "paymentMethod")

        # @return [String] Reference number of payment made.
        attribute?(:payment_reference, String, from: "paymentReference")

        # @return [String] Type of payment made.
        attribute?(:payment_type, String, from: "paymentType")

        # @return [Integer] Quantity of the item shipped.
        attribute?(:quantity_shipped, Integer, from: "quantityShipped")

        # @return [String] Stock keeping unit (SKU) of the item.
        attribute?(:sku, String)

        # @return [String] Start time of the transaction.
        attribute?(:start_time, String, from: "startTime")

        # @return [String] The store name associated with the transaction.
        attribute?(:store_name, String, from: "storeName")
      end
    end
  end
end
