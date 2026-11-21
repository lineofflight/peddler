# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module AnyOfferChanged
      NumberOfOffer = Structure.new do
        attribute(:condition, String, null: false, from: "Condition")

        attribute(:fulfillment_channel, String, null: false, from: "FulfillmentChannel")

        attribute(:offer_count, Integer, null: false, from: "OfferCount")
      end
    end
  end
end
