# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShippingV2
      # Rate Item for shipping (base cost, transaction fee, confirmation, insurance, etc.) Data source definition:
      RateItem = Structure.new do
        attribute?(:rate_item_charge, Money, from: "rateItemCharge")

        attribute?(:rate_item_id, String, from: "rateItemID")

        # Used for the localization.
        attribute?(:rate_item_name_localization, String, from: "rateItemNameLocalization")

        attribute?(:rate_item_type, String, from: "rateItemType")
      end
    end
  end
end
