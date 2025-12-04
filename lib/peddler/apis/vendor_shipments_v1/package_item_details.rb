# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorShipmentsV1
      # Item details for be provided for every item in shipment at either the item or carton or pallet level, whichever
      # is appropriate.
      PackageItemDetails = Structure.new do
        # @return [String] The two digit country code in ISO 3166-1 alpha-2 format representing the country where the
        #   product was manufactured or originated.
        attribute?(:country_of_origin, String, from: "countryOfOrigin")

        # @return [Expiry] Either expiryDate or mfgDate and expiryAfterDuration are mandatory for perishable items.
        attribute?(:expiry, Expiry)

        # @return [String] The batch or lot number associates an item with information the manufacturer considers
        #   relevant for traceability of the trade item to which the Element String is applied. The data may refer to
        #   the trade item itself or to items contained. This field is mandatory for all perishable items.
        attribute?(:lot_number, String, from: "lotNumber")

        # @return [String] This is a reference to the lot number source location meaning the place where the product was
        #   assigned a traceability lot number. This is mandatory for goods in scope of the FDA Food Safety
        #   Modernization Act (FSMA 204). If provided, lotNumberSourceType must also be specified.
        attribute?(:lot_number_source_reference, String, from: "lotNumberSourceReference")

        # @return [String] The type of reference for the lot number source. Must be provided when
        #   lotNumberSourceReference is specified.
        attribute?(:lot_number_source_type, String, from: "lotNumberSourceType")

        # @return [String] The purchase order number for the shipment being confirmed. If the items in this shipment
        #   belong to multiple purchase order numbers that are in particular carton or pallet within the shipment, then
        #   provide the purchaseOrderNumber at the appropriate carton or pallet level. Formatting Notes: 8-character
        #   alpha-numeric code.
        attribute?(:purchase_order_number, String, from: "purchaseOrderNumber")

        # @return [RegulationReferences] References to regulatory requirements and compliance information for the item.
        attribute?(:regulation_references, RegulationReferences, from: "regulationReferences")
      end
    end
  end
end
