# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorShipmentsV1
      # Item details for be provided for every item in shipment at either the item or carton or pallet level, whichever
      # is appropriate.
      ItemDetails = Structure.new do
        # @return [String] The two-character country code for the country where the product was manufactured or
        #   originates. Use ISO 3166-1 alpha-2 format.
        attribute?(:country_of_origin, String, from: "countryOfOrigin")

        # @return [Expiry] Expiry refers to the collection of dates required for certain items. These could be either
        #   expiryDate or mfgDate and expiryAfterDuration. These are mandatory for perishable items.
        attribute?(:expiry, Expiry)

        # @return [String] Identification of the instructions on how specified item/carton/pallet should be handled.
        attribute?(:handling_code, String, from: "handlingCode")

        # @return [String] The batch or lot number associates an item with information the manufacturer considers
        #   relevant for traceability of the trade item to which the Element String is applied. The data may refer to
        #   the trade item itself or to items contained. This field is mandatory for all perishable items.
        attribute?(:lot_number, String, from: "lotNumber")

        # @return [String] The location identifier where the product receives a traceability lot number. Provide this
        #   field for products subject to the FDA Food Safety Modernization Act (FSMA) Section 204. When you provide
        #   `lotNumberSourceReference`, you must also specify the corresponding `lotNumberSourceType` field.
        attribute?(:lot_number_source_reference, String, from: "lotNumberSourceReference")

        # @return [String] The identifier type used for the lot number source. Provide this field when you specify
        #   `lotNumberSourceReference`.
        attribute?(:lot_number_source_type, String, from: "lotNumberSourceType")

        # @return [Money] Maximum retail price of the item being shipped.
        attribute?(:maximum_retail_price, Money, from: "maximumRetailPrice")

        # @return [String] The purchase order number for the shipment being confirmed. If the items in this shipment
        #   belong to multiple purchase order numbers that are in particular carton or pallet within the shipment, then
        #   provide the purchaseOrderNumber at the appropriate carton or pallet level. Formatting Notes: 8-character
        #   alpha-numeric code.
        attribute?(:purchase_order_number, String, from: "purchaseOrderNumber")

        # @return [RegulationReferences] Regulatory requirements and compliance information for the item.
        attribute?(:regulation_references, RegulationReferences, from: "regulationReferences")
      end
    end
  end
end
