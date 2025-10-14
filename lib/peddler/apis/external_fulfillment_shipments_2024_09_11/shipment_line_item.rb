# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ExternalFulfillmentShipments20240911
      # Information about a line item in a shipment.
      ShipmentLineItem = Structure.new do
        # @return [Array<Charge>] The charges associated with the line item. The charge amount does not include the tax
        # amount.
        attribute(:charges, [Charge])

        # @return [ComplianceAttributes] All necessary compliance attributes specific to the line item.
        attribute(:compliance_attributes, ComplianceAttributes, from: "complianceAttributes")

        # @return [String] The seller's identifier for the SKU in this line item.
        attribute(:merchant_sku, String, from: "merchantSku")

        # @return [Integer] The number of items of the SKU in this line item.
        attribute(:number_of_units, Integer, from: "numberOfUnits")

        # @return [String] An identifier for a shipment's line item. This identifier is guaranteed to be unique within
        # the scope of its containing shipment.
        attribute(:shipment_line_item_id, String, from: "shipmentLineItemId")

        # @return [Array<Cancellation>] A list of cancellations for the given line item.
        attribute?(:cancellations, [Cancellation])

        # @return [String] The country of origin provided by the seller, represented by a two-letter country code in
        # ISO-3166 alpha-2 format. You must pass this field when `countryOfOriginRequirement` is `REQUIRED` in the
        # `getShipment` or `getShipments` response.
        attribute?(:country_of_origin, String, from: "countryOfOrigin")

        # @return [Array<CustomAttribute>] A list of custom passthrough attributes. For details on these attributes,
        # reach out to your respective program teams at Amazon.
        attribute?(:custom_attributes, [CustomAttribute], from: "customAttributes")

        # @return [GiftAttributes] Information about any gift wrapping that is needed for this line item.
        attribute?(:gift_attributes, GiftAttributes, from: "giftAttributes")

        # @return [Array<String>] A list of HAZMAT label identifiers that must be applied to the packages for this line
        # item.
        attribute?(:hazmat_labels, [String], from: "hazmatLabels")

        # @return [String] The HSN code of SKU in this line item.
        attribute?(:hsn_code, String, from: "hsnCode")

        # @return [Amount] The value of the item being shipped, as provided by the seller. This serves as the basis for
        # import duty/tax calculations. You must pass this field when `itemValueRequirement` is `REQUIRED` in the
        # `getShipment` or `getShipments` response.
        attribute?(:item_value, Amount, from: "itemValue")

        # @return [String] Whether the line item has multiple pieces.
        attribute?(:piece_type, String, from: "pieceType")

        # @return [String] The country of origin recommended by the marketplace, represented as a two-letter country
        # code following the ISO-3166 alpha-2 standard.
        attribute?(:recommended_country_of_origin, String, from: "recommendedCountryOfOrigin")

        # @return [String] The three digit currency code of the currency recommended by the marketplace, in ISO 4217
        # format.
        attribute?(:recommended_currency_code, String, from: "recommendedCurrencyCode")

        # @return [Array<SerialNumber>] The serial numbers for each item in this line item.
        attribute?(:serial_numbers, Array, from: "serialNumbers")
      end
    end
  end
end
