# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/money"
require "peddler/types/vendor_shipments_v1/expiry"

module Peddler
  module Types
    module VendorShipmentsV1
      # Item details for be provided for every item in shipment at either the item or carton or pallet level, whichever
      # is appropriate.
      ItemDetails = Structure.new do
        # @return [String] The purchase order number for the shipment being confirmed. If the items in this shipment
        # belong to multiple purchase order numbers that are in particular carton or pallet within the shipment, then
        # provide the purchaseOrderNumber at the appropriate carton or pallet level. Formatting Notes: 8-character
        # alpha-numeric code.
        attribute?(:purchase_order_number, String, from: "purchaseOrderNumber")

        # @return [String] The batch or lot number associates an item with information the manufacturer considers
        # relevant for traceability of the trade item to which the Element String is applied. The data may refer to the
        # trade item itself or to items contained. This field is mandatory for all perishable items.
        attribute?(:lot_number, String, from: "lotNumber")

        # @return [Expiry] Expiry refers to the collection of dates required for certain items. These could be either
        # expiryDate or mfgDate and expiryAfterDuration. These are mandatory for perishable items.
        attribute?(:expiry, Expiry)

        # @return [Money] Maximum retail price of the item being shipped.
        attribute?(:maximum_retail_price, Money, from: "maximumRetailPrice")

        # @return [String] Identification of the instructions on how specified item/carton/pallet should be handled.
        attribute?(:handling_code, String, from: "handlingCode")
      end
    end
  end
end
