# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShippingV2
      # An item in a package.
      Item = Structure.new do
        # The number of units. This value is required.
        attribute(:quantity, Integer, null: false)

        attribute?(:dangerous_goods_details, DangerousGoodsDetails, from: "dangerousGoodsDetails")

        # The product description of the item.
        attribute?(:description, String)

        attribute?(:direct_fulfillment_item_identifiers, DirectFulfillmentItemIdentifiers, from: "directFulfillmentItemIdentifiers")

        attribute?(:invoice_details, InvoiceDetails, from: "invoiceDetails")

        # When true, the item qualifies as hazardous materials (hazmat). Defaults to false.
        attribute?(:hazmat, :boolean, from: "isHazmat")

        # A unique identifier for an item provided by the client.
        attribute?(:item_identifier, String, from: "itemIdentifier")

        attribute?(:item_value, Money, from: "itemValue")

        attribute?(:liquid_volume, LiquidVolume, from: "liquidVolume")

        # The product type of the item.
        attribute?(:product_type, String, from: "productType")

        # A list of unique serial numbers in an Amazon package that can be used to guarantee non-fraudulent items. The
        # number of serial numbers in the list must be less than or equal to the quantity of items being shipped. Only
        # applicable when channel source is Amazon.
        attribute?(:serial_numbers, [String], from: "serialNumbers")

        attribute?(:weight, Weight)
      end
    end
  end
end
