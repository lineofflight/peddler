# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20200701
      # The request body schema for the `getDeliveryOfferings` operation.
      GetDeliveryOfferingsRequest = Structure.new do
        # @return [VariablePrecisionAddress] The address for the delivery offering.
        attribute(:destination_address, VariablePrecisionAddress, from: "destinationAddress")

        # @return [String] The seller SKU of the item.
        attribute(:seller_sku, String, from: "sellerSku")

        # @return [String] The two digit country code the items should ship from. In ISO 3166-1 alpha-2 format.
        attribute(:ship_from_country_code, String, from: "shipFromCountryCode")

        # @return [DeliveryQuantity] The quantity of the request SKU.
        attribute?(:quantity, DeliveryQuantity)
      end
    end
  end
end
