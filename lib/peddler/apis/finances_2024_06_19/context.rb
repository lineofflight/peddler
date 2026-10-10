# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module Finances20240619
      # Additional information about the item.
      Context = Structure.new do
        # The type of context.
        attribute(:context_type, String, null: false, from: "contextType")

        # The Amazon Standard Identification Number (ASIN) of the item.
        attribute?(:asin, String)

        # The channel of the transaction. For example: `MFN`.
        attribute?(:channel, String)

        # The deferral policy applied to the transaction.
        #
        # **Examples:** `B2B` (invoiced orders), `DD7` (delivery date policy)
        attribute?(:deferral_reason, String, from: "deferralReason")

        # The end time of the transaction.
        attribute?(:end_time, String, from: "endTime")

        # The fulfillment network of the item.
        attribute?(:fulfillment_network, String, from: "fulfillmentNetwork")

        # The release date of the transaction.
        attribute?(:maturity_date, String, from: "maturityDate")

        # The order type of the transaction.
        attribute?(:order_type, String, from: "orderType")

        # The date of the payment.
        attribute?(:payment_date, String, from: "paymentDate")

        # The method of payment.
        attribute?(:payment_method, String, from: "paymentMethod")

        # The reference number of the payment.
        attribute?(:payment_reference, String, from: "paymentReference")

        # The type of payment.
        attribute?(:payment_type, String, from: "paymentType")

        # The quantity of the item shipped.
        attribute?(:quantity_shipped, Integer, from: "quantityShipped")

        # The Stock Keeping Unit (SKU) of the item.
        attribute?(:sku, String)

        # The start time of the transaction.
        attribute?(:start_time, String, from: "startTime")

        # The store name associated with the transaction.
        attribute?(:store_name, String, from: "storeName")
      end
    end
  end
end
