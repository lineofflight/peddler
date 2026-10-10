# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module PricingHealth
      OfferCount = Structure.new do
        attribute(:condition, String, null: false)

        attribute(:fulfillment_type, String, null: false, from: "fulfillmentType")

        # The total number of offers for the specified condition and fulfillment channel
        attribute(:offer_count, Integer, null: false, from: "offerCount")
      end
    end
  end
end
