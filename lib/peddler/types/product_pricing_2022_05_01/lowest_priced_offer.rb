# frozen_string_literal: true

require "peddler/types/product_pricing_2022_05_01/lowest_priced_offers_input"
require "peddler/types/product_pricing_2022_05_01/offer"

module Peddler
  module Types
    module ProductPricing20220501
      # Describes the lowest priced offers for the specified item condition and offer type.
      LowestPricedOffer = Structure.new do
        # @return [LowestPricedOffersInput] The filtering criteria that are used to retrieve the lowest priced offers
        # that correspond to the `lowestPricedOffersInputs` request.
        attribute(:lowest_priced_offers_input, LowestPricedOffersInput, from: "lowestPricedOffersInput")

        # @return [Array<Offer>] A list of up to 20 lowest priced offers that match the criteria specified in
        # `lowestPricedOffersInput`.
        attribute(:offers, [Offer])
      end
    end
  end
end
