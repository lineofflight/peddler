# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class MerchantFulfillmentV0
      # Request schema.
      GetAdditionalSellerInputsRequest = Structure.new do
        # @return [String] An Amazon defined order identifier
        attribute(:order_id, String, null: false, from: "OrderId")

        # @return [Address] The address from which to ship.
        attribute(:ship_from_address, Address, null: false, from: "ShipFromAddress")

        # @return [String]
        attribute(:shipping_service_id, String, null: false, from: "ShippingServiceId")
      end
    end
  end
end
