# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/money"
require "peddler/types/product_pricing_2022_05_01/shipping_option"
require "peddler/types/product_pricing_2022_05_01/points"
require "peddler/types/product_pricing_2022_05_01/prime_details"
require "peddler/types/product_pricing_2022_05_01/featured_offer_segment"

module Peddler
  module Types
    module ProductPricing20220501
      # A product offer with segment information indicating where it's featured.
      SegmentedFeaturedOffer = Structure.new do
        # @return [String] The seller identifier for the offer.
        attribute(:seller_id, String, from: "sellerId")

        # @return [String] Item Condition.
        attribute(:condition, String)

        # @return [String] The item subcondition of the offer.
        attribute?(:sub_condition, String, from: "subCondition")

        # @return [String] The fulfillment type for the offer. Possible values are `AFN` (Amazon Fulfillment Network)
        # and `MFN` (Merchant Fulfillment Network).
        attribute(:fulfillment_type, String, from: "fulfillmentType")

        # @return [Money] The offer buying price. This doesn't include shipping, points, or applicable promotions.
        attribute(:listing_price, Money, from: "listingPrice")

        # @return [Array<ShippingOption>] A list of shipping options associated with this offer
        attribute?(:shipping_options, [ShippingOption], from: "shippingOptions")

        # @return [Points] The number of Amazon Points that are offered with the purchase of an item and the monetary
        # value of these points. Note that the Points element is only returned in Japan (JP).
        attribute?(:points, Points)

        # @return [PrimeDetails] Amazon Prime details.
        attribute?(:prime_details, PrimeDetails, from: "primeDetails")

        # @return [Array<FeaturedOfferSegment>] The list of segment information in which the offer is featured.
        attribute(:featured_offer_segments, [FeaturedOfferSegment], from: "featuredOfferSegments")
      end
    end
  end
end
