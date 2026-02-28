# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductPricingV0
      # The number of offer listings with the specified condition.
      OfferListingCountType = Structure.new do
        # @return [Integer] The number of offer listings.
        attribute(:count, Integer, null: false, from: "Count")

        # @return [String] The condition of the item.
        attribute(:condition, String, null: false)
      end
    end
  end
end
