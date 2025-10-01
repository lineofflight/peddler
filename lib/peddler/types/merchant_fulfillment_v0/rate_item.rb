# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/money"
require "structure"

module Peddler
  module Types
    module MerchantFulfillmentV0
      # Rate item for shipping costs and adjustments.
      RateItem = Structure.new do
        # @return [String] Unique identifier for the RateItem.
        attribute(:rate_item_id, String, from: "RateItemID")

        # @return [Money] The monetary value for the RateItem.
        attribute?(:rate_item_charge, Money, from: "RateItemCharge")

        # @return [String] Localized name for the RateItem.
        attribute?(:rate_item_name_localization, String, from: "RateItemNameLocalization")

        # @return [String] Type of the RateItem.
        attribute?(:rate_item_type, String, from: "RateItemType")
      end
    end
  end
end
