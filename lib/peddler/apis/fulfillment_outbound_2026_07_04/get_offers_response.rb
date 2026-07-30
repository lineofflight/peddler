# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20260704
      # The response schema for `getOffers`.
      GetOffersResponse = Structure.new do
        # @return [Array<OfferResult>] Per-item offer results. Each entry contains the item, its available offers, and
        #   any constraints that prevented offers.
        attribute?(:offer_results, [OfferResult], from: "offerResults")
      end
    end
  end
end
