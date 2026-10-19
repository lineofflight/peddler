# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ProductPricing20220501
      # A product offer with segment information indicating where it's featured.
      SegmentedFeaturedOffer = Structure.new do
        # Item Condition. Known values: `New`, `Used`, `Collectible`, `Refurbished`, `Club`.
        attribute(:condition, String, null: false)

        # The list of segment information in which the offer is featured.
        attribute(:featured_offer_segments, [FeaturedOfferSegment], null: false, from: "featuredOfferSegments")

        # The fulfillment type for the offer. Possible values are `AFN` (Amazon Fulfillment Network) and `MFN` (Merchant
        # Fulfillment Network).
        attribute(:fulfillment_type, String, null: false, from: "fulfillmentType")

        # The offer buying price. This doesn't include shipping, points, or applicable promotions.
        attribute(:listing_price, Money, null: false, from: "listingPrice")

        # The seller identifier for the offer.
        attribute(:seller_id, String, null: false, from: "sellerId")

        # The number of Amazon Points that are offered with the purchase of an item and the monetary value of these
        # points. Note that the Points element is only returned in Japan (JP).
        attribute?(:points, Points)

        # Amazon Prime details.
        attribute?(:prime_details, PrimeDetails, from: "primeDetails")

        # A list of live promotions with this offer
        attribute?(:promotions, [Promotion])

        # A list of shipping options associated with this offer
        attribute?(:shipping_options, [ShippingOption], from: "shippingOptions")

        # The item subcondition of the offer. Known values: `New`, `Mint`, `VeryGood`, `Good`, `Acceptable`, `Poor`,
        # `Club`, `OEM`, `Warranty`, `RefurbishedWarranty`, `Refurbished`, `OpenBox`, `Other`.
        attribute?(:sub_condition, String, from: "subCondition")
      end
    end
  end
end
