# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV2
      # Rate Item for shipping (base cost, transaction fee, confirmation, insurance, etc.) Data source definition:
      RateItem = Structure.new do
        # @return [Money]
        attribute?(:rate_item_charge, Money, from: "rateItemCharge")

        # @return [String]
        attribute?(:rate_item_id, String, from: "rateItemID")

        # @return [String] Used for the localization.
        attribute?(:rate_item_name_localization, String, from: "rateItemNameLocalization")

        # @return [String]
        attribute?(:rate_item_type, String, from: "rateItemType")
      end
    end
  end
end
