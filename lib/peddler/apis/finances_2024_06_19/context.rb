# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Finances20240619
      # Additional Information about the item.
      Context = Structure.new do
        # @return [String]
        attribute(:context_type, String, null: false, from: "contextType")

        # @return [String] The Amazon Standard Identification Number (ASIN) of the item.
        attribute?(:asin, String)

        # @return [String] Channel details of related transaction.
        attribute?(:channel, String)

        # @return [String] The deferral policy applied to the transaction.
        #
        # **Examples:** `B2B` (invoiced orders), `DD7` (delivery date policy)
        attribute?(:deferral_reason, String, from: "deferralReason")

        # @return [String] The end time of the transaction.
        attribute?(:end_time, String, from: "endTime")

        # @return [String] The fulfillment network of the item.
        attribute?(:fulfillment_network, String, from: "fulfillmentNetwork")

        # @return [String] The release date of the transaction.
        attribute?(:maturity_date, String, from: "maturityDate")

        # @return [String] The transaction's order type.
        attribute?(:order_type, String, from: "orderType")

        # @return [String] The date of the payment.
        attribute?(:payment_date, String, from: "paymentDate")

        # @return [String] The method of payment.
        attribute?(:payment_method, String, from: "paymentMethod")

        # @return [String] The reference number of the payment.
        attribute?(:payment_reference, String, from: "paymentReference")

        # @return [String] The type of payment.
        attribute?(:payment_type, String, from: "paymentType")

        # @return [Integer] The quantity of the item shipped.
        attribute?(:quantity_shipped, Integer, from: "quantityShipped")

        # @return [String] The Stock Keeping Unit (SKU) of the item.
        attribute?(:sku, String)

        # @return [String] The start time of the transaction.
        attribute?(:start_time, String, from: "startTime")

        # @return [String] The store name associated with the transaction.
        attribute?(:store_name, String, from: "storeName")
      end
    end
  end
end
