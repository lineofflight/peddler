# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module AnyOfferChanged
      OfferChangeTrigger = Structure.new do
        # @return [String]
        attribute(:asin, String, from: "ASIN")

        # @return [String]
        attribute(:item_condition, String, from: "ItemCondition")

        # @return [String]
        attribute(:marketplace_id, String, from: "MarketplaceId")

        # @return [String]
        attribute(:offer_change_type, String, from: "OfferChangeType")

        # @return [String]
        attribute(:time_of_offer_change, String, from: "TimeOfOfferChange")
      end
    end
  end
end
