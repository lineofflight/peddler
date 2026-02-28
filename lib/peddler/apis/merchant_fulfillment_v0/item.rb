# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class MerchantFulfillmentV0
      # An Amazon order item identifier and a quantity.
      Item = Structure.new do
        # @return [String]
        attribute(:order_item_id, String, null: false, from: "OrderItemId")

        # @return [Integer]
        attribute(:quantity, Integer, null: false, from: "Quantity")

        # @return [DangerousGoodsDetails]
        attribute?(:dangerous_goods_details, DangerousGoodsDetails, from: "DangerousGoodsDetails")

        # @return [:boolean] When true, the item qualifies as hazardous materials (hazmat). Defaults to false.
        attribute?(:hazmat, :boolean, from: "IsHazmat")

        # @return [String]
        attribute?(:item_description, String, from: "ItemDescription")

        # @return [Array<AdditionalSellerInputs>] A list of additional seller inputs required to ship this item using
        #   the chosen shipping service.
        attribute?(:item_level_seller_inputs_list, [AdditionalSellerInputs], from: "ItemLevelSellerInputsList")

        # @return [Weight]
        attribute?(:item_weight, Weight, from: "ItemWeight")

        # @return [LiquidVolume]
        attribute?(:liquid_volume, LiquidVolume, from: "LiquidVolume")

        # @return [Array<TransparencyCode>]
        attribute?(:transparency_code_list, Array, from: "TransparencyCodeList")
      end
    end
  end
end
