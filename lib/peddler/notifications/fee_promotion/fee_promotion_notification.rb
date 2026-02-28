# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Notifications
    module FeePromotion
      # Nested notification data
      FeePromotionNotification = Structure.new do
        # @return [String]
        attribute(:fee_promotion_type, String, null: false, from: "FeePromotionType")

        # @return [String]
        attribute(:fee_promotion_type_description, String, null: false, from: "FeePromotionTypeDescription")

        # @return [Array<Identifier>]
        attribute(:identifiers, [Identifier], null: false, from: "Identifiers")

        # @return [String]
        attribute(:marketplace_id, String, null: false, from: "MarketplaceId")

        # @return [String]
        attribute(:merchant_id, String, null: false, from: "MerchantId")

        # @return [PromotionActiveTimeRange]
        attribute(:promotion_active_time_range, PromotionActiveTimeRange, null: false, from: "PromotionActiveTimeRange")

        # @return [Array<PromotionInformation>]
        attribute(:promotion_information, [PromotionInformation], null: false, from: "PromotionInformation")
      end
    end
  end
end
