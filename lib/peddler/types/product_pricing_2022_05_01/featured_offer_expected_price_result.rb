# frozen_string_literal: true

require "peddler/types/product_pricing_2022_05_01/featured_offer_expected_price"
require "peddler/types/product_pricing_2022_05_01/featured_offer"

module Peddler
  module Types
    module ProductPricing20220501
      # The FOEP result data for the requested offer.
      FeaturedOfferExpectedPriceResult = Structure.new do
        # @return [FeaturedOfferExpectedPrice]
        attribute(:featured_offer_expected_price, FeaturedOfferExpectedPrice, from: "featuredOfferExpectedPrice")

        # @return [String] The status of the FOEP computation. Possible values include `VALID_FOEP`,
        # `NO_COMPETING_OFFER`, `OFFER_NOT_ELIGIBLE`, `OFFER_NOT_FOUND`, and `ASIN_NOT_ELIGIBLE`. Additional values
        # might be added in the future.
        attribute(:result_status, String, from: "resultStatus")

        # @return [FeaturedOffer] The offer that will likely be the featured offer if the target offer is priced above
        # its FOEP. If the target offer is currently the featured offer, this property will be different than
        # `currentFeaturedOffer`.
        attribute(:competing_featured_offer, FeaturedOffer, from: "competingFeaturedOffer")

        # @return [FeaturedOffer] The offer that is currently the featured offer. If the target offer is not currently
        # featured, then this property will be equal to `competingFeaturedOffer`.
        attribute(:current_featured_offer, FeaturedOffer, from: "currentFeaturedOffer")
      end
    end
  end
end
