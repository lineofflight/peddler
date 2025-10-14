# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductPricing20220501
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
