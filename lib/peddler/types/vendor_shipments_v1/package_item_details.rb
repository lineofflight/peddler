# frozen_string_literal: true

require "peddler/types/vendor_shipments_v1/expiry"

module Peddler
  module Types
    module VendorShipmentsV1
      # Item details for be provided for every item in shipment at either the item or carton or pallet level, whichever
      # is appropriate.
      PackageItemDetails = Structure.new do
        # @return [String] The purchase order number for the shipment being confirmed. If the items in this shipment
        # belong to multiple purchase order numbers that are in particular carton or pallet within the shipment, then
        # provide the purchaseOrderNumber at the appropriate carton or pallet level. Formatting Notes: 8-character
        # alpha-numeric code.
        attribute(:purchase_order_number, String, from: "purchaseOrderNumber")

        # @return [String] The batch or lot number associates an item with information the manufacturer considers
        # relevant for traceability of the trade item to which the Element String is applied. The data may refer to the
        # trade item itself or to items contained. This field is mandatory for all perishable items.
        attribute(:lot_number, String, from: "lotNumber")

        # @return [Expiry] Either expiryDate or mfgDate and expiryAfterDuration are mandatory for perishable items.
        attribute(:expiry, Expiry)
      end
    end
  end
end
