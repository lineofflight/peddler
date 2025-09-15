# frozen_string_literal: true

require "peddler/types/shipping_v2/currency"
require "peddler/types/shipping_v2/weight"
require "peddler/types/shipping_v2/liquid_volume"
require "peddler/types/shipping_v2/dangerous_goods_details"
require "peddler/types/shipping_v2/invoice_details"
require "peddler/types/shipping_v2/direct_fulfillment_item_identifiers"

module Peddler
  module Types
    module ShippingV2
      # An item in a package.
      Item = Structure.new do
        # @return [Currency]
        attribute(:item_value, Currency, from: "itemValue")

        # @return [String] The product description of the item.
        attribute(:description, String)

        # @return [String] A unique identifier for an item provided by the client.
        attribute(:item_identifier, String, from: "itemIdentifier")

        # @return [Integer] The number of units. This value is required.
        attribute(:quantity, Integer)

        # @return [Weight]
        attribute(:weight, Weight)

        # @return [LiquidVolume]
        attribute(:liquid_volume, LiquidVolume, from: "liquidVolume")

        # @return [:boolean] When true, the item qualifies as hazardous materials (hazmat). Defaults to false.
        attribute(:is_hazmat, :boolean, from: "isHazmat")

        # @return [DangerousGoodsDetails]
        attribute(:dangerous_goods_details, DangerousGoodsDetails, from: "dangerousGoodsDetails")

        # @return [String] The product type of the item.
        attribute(:product_type, String, from: "productType")

        # @return [InvoiceDetails]
        attribute(:invoice_details, InvoiceDetails, from: "invoiceDetails")

        # @return [Array<String>] A list of unique serial numbers in an Amazon package that can be used to guarantee
        # non-fraudulent items. The number of serial numbers in the list must be less than or equal to the quantity of
        # items being shipped. Only applicable when channel source is Amazon.
        attribute(:serial_numbers, [String], from: "serialNumbers")

        # @return [DirectFulfillmentItemIdentifiers]
        attribute(:direct_fulfillment_item_identifiers, DirectFulfillmentItemIdentifiers, from: "directFulfillmentItemIdentifiers")
      end
    end
  end
end
