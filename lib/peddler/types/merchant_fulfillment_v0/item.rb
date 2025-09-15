# frozen_string_literal: true

require "peddler/types/merchant_fulfillment_v0/weight"
require "peddler/types/merchant_fulfillment_v0/additional_seller_inputs"
require "peddler/types/merchant_fulfillment_v0/liquid_volume"
require "peddler/types/merchant_fulfillment_v0/dangerous_goods_details"

module Peddler
  module Types
    module MerchantFulfillmentV0
      # An Amazon order item identifier and a quantity.
      Item = Structure.new do
        # @return [String]
        attribute(:order_item_id, String, from: "OrderItemId")

        # @return [Integer]
        attribute(:quantity, Integer, from: "Quantity")

        # @return [Weight]
        attribute(:item_weight, Weight, from: "ItemWeight")

        # @return [String]
        attribute(:item_description, String, from: "ItemDescription")

        # @return [Array<TransparencyCode>]
        attribute(:transparency_code_list, Array, from: "TransparencyCodeList")

        # @return [Array<AdditionalSellerInputs>] A list of additional seller inputs required to ship this item using
        # the chosen shipping service.
        attribute(:item_level_seller_inputs_list, [AdditionalSellerInputs], from: "ItemLevelSellerInputsList")

        # @return [LiquidVolume]
        attribute(:liquid_volume, LiquidVolume, from: "LiquidVolume")

        # @return [:boolean] When true, the item qualifies as hazardous materials (hazmat). Defaults to false.
        attribute(:hazmat, :boolean, from: "IsHazmat")

        # @return [DangerousGoodsDetails]
        attribute(:dangerous_goods_details, DangerousGoodsDetails, from: "DangerousGoodsDetails")
      end
    end
  end
end
