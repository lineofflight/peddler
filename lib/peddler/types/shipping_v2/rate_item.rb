# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/shipping_v2/currency"

module Peddler
  module Types
    module ShippingV2
      # Rate Item for shipping (base cost, transaction fee, confirmation, insurance, etc.) Data source definition:
      RateItem = Structure.new do
        # @return [String]
        attribute(:rate_item_id, String, from: "rateItemID")

        # @return [String]
        attribute(:rate_item_type, String, from: "rateItemType")

        # @return [Currency]
        attribute(:rate_item_charge, Currency, from: "rateItemCharge")

        # @return [String] Used for the localization.
        attribute(:rate_item_name_localization, String, from: "rateItemNameLocalization")
      end
    end
  end
end
