# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/merchant_fulfillment_v0/item_level_fields"
require "peddler/types/merchant_fulfillment_v0/additional_inputs"

module Peddler
  module Types
    module MerchantFulfillmentV0
      # The payload for the `getAdditionalSellerInputs` operation.
      GetAdditionalSellerInputsResult = Structure.new do
        # @return [Array<ItemLevelFields>]
        attribute?(:item_level_fields_list, [ItemLevelFields], from: "ItemLevelFieldsList")

        # @return [Array<AdditionalInputs>]
        attribute?(:shipment_level_fields, [AdditionalInputs], from: "ShipmentLevelFields")
      end
    end
  end
end
