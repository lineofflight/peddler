# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductPricing20220501
      # The FOEP result data for the requested offer.
      FeaturedOfferExpectedPriceResult = Structure.new do
        # @return [String] The status of the FOEP computation. Possible values include `VALID_FOEP`,
        #   `NO_COMPETING_OFFER`, `OFFER_NOT_ELIGIBLE`, `OFFER_NOT_FOUND`, and `ASIN_NOT_ELIGIBLE`. Additional values
        #   might be added in the future.
        attribute(:result_status, String, from: "resultStatus")

        # @return [FeaturedOffer] The offer that will likely be the featured offer if the target offer is priced above
        #   its FOEP. If the target offer is currently the featured offer, this property will be different than
        #   `currentFeaturedOffer`.
        attribute?(:competing_featured_offer, FeaturedOffer, from: "competingFeaturedOffer")

        # @return [FeaturedOffer] The offer that is currently the featured offer. If the target offer is not currently
        #   featured, then this property will be equal to `competingFeaturedOffer`.
        attribute?(:current_featured_offer, FeaturedOffer, from: "currentFeaturedOffer")

        # @return [FeaturedOfferExpectedPrice]
        attribute?(:featured_offer_expected_price, FeaturedOfferExpectedPrice, from: "featuredOfferExpectedPrice")
      end
    end
  end
end
