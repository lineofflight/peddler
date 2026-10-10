# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module MerchantFulfillmentV0
      # An Amazon order item identifier and a quantity.
      Item = Structure.new do
        attribute(:order_item_id, String, null: false, from: "OrderItemId")

        attribute(:quantity, Integer, null: false, from: "Quantity")

        attribute?(:dangerous_goods_details, DangerousGoodsDetails, from: "DangerousGoodsDetails")

        # When true, the item qualifies as hazardous materials (hazmat). Defaults to false.
        attribute?(:hazmat, :boolean, from: "IsHazmat")

        attribute?(:item_description, String, from: "ItemDescription")

        # A list of additional seller inputs required to ship this item using the chosen shipping service.
        attribute?(:item_level_seller_inputs_list, [AdditionalSellerInputs], from: "ItemLevelSellerInputsList")

        attribute?(:item_weight, Weight, from: "ItemWeight")

        attribute?(:liquid_volume, LiquidVolume, from: "LiquidVolume")

        attribute?(:transparency_code_list, Array, from: "TransparencyCodeList")
      end
    end
  end
end
