# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/merchant_fulfillment_v0/additional_inputs"
require "peddler/types/merchant_fulfillment_v0/item_level_fields"

module Peddler
  module Types
    module MerchantFulfillmentV0
      # The payload for the `getAdditionalSellerInputs` operation.
      GetAdditionalSellerInputsResult = Structure.new do
        # @return [Array<AdditionalInputs>]
        attribute(:shipment_level_fields, [AdditionalInputs], from: "ShipmentLevelFields")

        # @return [Array<ItemLevelFields>]
        attribute(:item_level_fields_list, [ItemLevelFields], from: "ItemLevelFieldsList")
      end
    end
  end
end
