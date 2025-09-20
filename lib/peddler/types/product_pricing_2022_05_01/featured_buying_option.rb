# frozen_string_literal: true

require "peddler/types/product_pricing_2022_05_01/segmented_featured_offer"

module Peddler
  module Types
    module ProductPricing20220501
      # Describes a featured buying option, which includes a list of segmented featured offers for a particular item
      # condition.
      FeaturedBuyingOption = Structure.new do
        # @return [String] The buying option type for the featured offer. `buyingOptionType` represents the buying
        # options that a customer receives on the detail page, such as `B2B`, `Fresh`, and `Subscribe n Save`.
        # `buyingOptionType` currently supports `NEW` as a value.
        attribute(:buying_option_type, String, from: "buyingOptionType")

        # @return [Array<SegmentedFeaturedOffer>] A list of segmented featured offers for the current buying option
        # type. A segment can be considered as a group of regional contexts that all have the same featured offer. A
        # regional context is a combination of factors such as customer type, region, or postal code and buying option.
        attribute(:segmented_featured_offers, [SegmentedFeaturedOffer], from: "segmentedFeaturedOffers")
      end
    end
  end
end
