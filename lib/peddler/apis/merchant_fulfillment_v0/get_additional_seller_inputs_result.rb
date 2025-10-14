# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class MerchantFulfillmentV0
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
