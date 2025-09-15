# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module ProductPricingV0
      # The total number of offers for the specified condition and fulfillment channel.
      OfferCountType = Structure.new do
        # @return [String] Indicates the condition of the item. For example: New, Used, Collectible, Refurbished, or
        # Club.
        attribute(:condition, String)

        # @return [String] Indicates whether the item is fulfilled by Amazon or by the seller.
        attribute(:fulfillment_channel, String, from: "fulfillmentChannel")

        # @return [Integer] The number of offers in a fulfillment channel that meet a specific condition.
        attribute(:offer_count, Integer, from: "OfferCount")
      end
    end
  end
end
