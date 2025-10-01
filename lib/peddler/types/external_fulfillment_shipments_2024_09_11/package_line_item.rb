# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/external_fulfillment_shipments_2024_09_11/amount"

module Peddler
  module Types
    module ExternalFulfillmentShipments20240911
      # A line item in a package.
      PackageLineItem = Structure.new do
        # @return [String] The line item ID.
        attribute(:package_line_item_id, String, from: "packageLineItemId")

        # @return [Integer] The number of items of a particular line item of a shipment that are packed into the
        # package.
        attribute(:quantity, Integer)

        # @return [String] The country of origin provided by the seller, represented by a two-letter country code in
        # ISO-3166 alpha-2 format. You must pass this field when `countryOfOriginRequirement` is `REQUIRED` in the
        # `getShipment` or `getShipments` response.
        attribute?(:country_of_origin, String, from: "countryOfOrigin")

        # @return [Amount] The value of the item being shipped, as provided by the seller. This serves as the basis for
        # import duty/tax calculations. You must pass this field when `itemValueRequirement` is `REQUIRED` in the
        # `getShipment` or `getShipments` response.
        attribute?(:item_value, Amount, from: "itemValue")

        # @return [Integer] The number of pieces of a multi-piece item that are in this package. This is applicable only
        # for items that are shipped in multiple pieces.
        attribute?(:pieces, Integer)

        # @return [Array<SerialNumber>] The list of serial numbers of items in the package, if required to be provided.
        attribute?(:serial_numbers, Array, from: "serialNumbers")
      end
    end
  end
end
