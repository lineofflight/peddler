# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductPricingV0
      # The total number of offers for the specified condition and fulfillment channel.
      OfferCountType = Structure.new do
        # @return [Integer] The number of offers in a fulfillment channel that meet a specific condition.
        attribute?(:offer_count, Integer, from: "OfferCount")

        # @return [String] Indicates the condition of the item. For example: New, Used, Collectible, Refurbished, or
        #   Club.
        attribute?(:condition, String)

        # @return [String] Indicates whether the item is fulfilled by Amazon or by the seller.
        attribute?(:fulfillment_channel, String, from: "fulfillmentChannel")
      end
    end
  end
end
