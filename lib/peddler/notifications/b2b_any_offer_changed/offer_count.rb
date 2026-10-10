# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module B2BAnyOfferChanged
      OfferCount = Structure.new do
        attribute(:condition, String, null: false, from: "Condition")

        attribute(:fulfillment_channel, String, null: false, from: "FulfillmentChannel")

        # The total number of offers for the specified condition and fulfillment channel
        attribute?(:offer_count, Integer, from: "OfferCount")
      end
    end
  end
end
