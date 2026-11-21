# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module AnyOfferChanged
      OfferChangeTrigger = Structure.new do
        attribute(:asin, String, null: false, from: "ASIN")

        attribute(:item_condition, String, null: false, from: "ItemCondition")

        attribute(:marketplace_id, String, null: false, from: "MarketplaceId")

        attribute(:offer_change_type, String, null: false, from: "OfferChangeType")

        attribute(:time_of_offer_change, String, null: false, from: "TimeOfOfferChange")
      end
    end
  end
end
