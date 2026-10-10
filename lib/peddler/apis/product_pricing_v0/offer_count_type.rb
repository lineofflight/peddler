# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ProductPricingV0
      # The total number of offers for the specified condition and fulfillment channel.
      OfferCountType = Structure.new do
        # The number of offers in a fulfillment channel that meet a specific condition.
        attribute?(:offer_count, Integer, from: "OfferCount")

        # Indicates the condition of the item. For example: New, Used, Collectible, Refurbished, or Club.
        attribute?(:condition, String)

        # Indicates whether the item is fulfilled by Amazon or by the seller.
        attribute?(:fulfillment_channel, String, from: "fulfillmentChannel")
      end
    end
  end
end
