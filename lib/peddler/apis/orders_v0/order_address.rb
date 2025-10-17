# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class OrdersV0
      # The shipping address for the order.
      OrderAddress = Structure.new do
        # @return [String] An Amazon-defined order identifier, in 3-7-7 format.
        attribute(:amazon_order_id, String, from: "AmazonOrderId")

        # @return [String] The company name of the contact buyer. For IBA orders, the buyer company must be Amazon
        #   entities.
        attribute?(:buyer_company_name, String, from: "BuyerCompanyName")

        # @return [DeliveryPreferences]
        attribute?(:delivery_preferences, DeliveryPreferences, from: "DeliveryPreferences")

        # @return [Address] The shipping address for the order.
        #
        # **Note**: `ShippingAddress` is only available for orders with the following status values: `Unshipped`,
        #   `PartiallyShipped`, `Shipped`, and `InvoiceUnconfirmed`.
        attribute?(:shipping_address, Address, from: "ShippingAddress")
      end
    end
  end
end
