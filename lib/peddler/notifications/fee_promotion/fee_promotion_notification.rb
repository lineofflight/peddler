# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Notifications
    module FeePromotion
      # Nested notification data
      FeePromotionNotification = Structure.new do
        attribute(:fee_promotion_type, String, null: false, from: "FeePromotionType")

        attribute(:fee_promotion_type_description, String, null: false, from: "FeePromotionTypeDescription")

        attribute(:identifiers, [Identifier], null: false, from: "Identifiers")

        attribute(:marketplace_id, String, null: false, from: "MarketplaceId")

        attribute(:merchant_id, String, null: false, from: "MerchantId")

        attribute(:promotion_active_time_range, PromotionActiveTimeRange, null: false, from: "PromotionActiveTimeRange")

        attribute(:promotion_information, [PromotionInformation], null: false, from: "PromotionInformation")
      end
    end
  end
end
