# frozen_string_literal: true

require "peddler/types/merchant_fulfillment_v0/address"

module Peddler
  module Types
    module MerchantFulfillmentV0
      # Request schema.
      GetAdditionalSellerInputsRequest = Structure.new do
        # @return [String]
        attribute(:shipping_service_id, String, from: "ShippingServiceId")

        # @return [Address] The address from which to ship.
        attribute(:ship_from_address, Address, from: "ShipFromAddress")

        # @return [String] An Amazon defined order identifier
        attribute(:order_id, String, from: "OrderId")
      end
    end
  end
end
