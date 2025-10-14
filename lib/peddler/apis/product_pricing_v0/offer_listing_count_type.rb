# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductPricingV0
      # The number of offer listings with the specified condition.
      OfferListingCountType = Structure.new do
        # @return [Integer] The number of offer listings.
        attribute(:count, Integer, from: "Count")

        # @return [String] The condition of the item.
        attribute(:condition, String)
      end
    end
  end
end
