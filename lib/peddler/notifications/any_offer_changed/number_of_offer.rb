# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module AnyOfferChanged
      NumberOfOffer = Structure.new do
        # @return [String]
        attribute(:condition, String, null: false, from: "Condition")

        # @return [String]
        attribute(:fulfillment_channel, String, null: false, from: "FulfillmentChannel")

        # @return [Integer]
        attribute(:offer_count, Integer, null: false, from: "OfferCount")
      end
    end
  end
end
