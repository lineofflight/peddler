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
        attribute(:fee_promotion_type, String, from: "FeePromotionType")

        # @return [String]
        attribute(:fee_promotion_type_description, String, from: "FeePromotionTypeDescription")

        # @return [Array<Identifier>]
        attribute(:identifiers, [Identifier], from: "Identifiers")

        # @return [String]
        attribute(:marketplace_id, String, from: "MarketplaceId")

        # @return [String]
        attribute(:merchant_id, String, from: "MerchantId")

        # @return [PromotionActiveTimeRange]
        attribute(:promotion_active_time_range, PromotionActiveTimeRange, from: "PromotionActiveTimeRange")

        # @return [Array<PromotionInformation>]
        attribute(:promotion_information, [PromotionInformation], from: "PromotionInformation")
      end
    end
  end
end
