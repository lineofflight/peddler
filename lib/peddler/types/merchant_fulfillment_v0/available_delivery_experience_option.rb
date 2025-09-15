# frozen_string_literal: true

require "peddler/types/merchant_fulfillment_v0/currency_amount"

module Peddler
  module Types
    module MerchantFulfillmentV0
      # The available delivery confirmation options, and the fee charged, if any.
      AvailableDeliveryExperienceOption = Structure.new do
        # @return [String]
        attribute(:delivery_experience_option, String, from: "DeliveryExperienceOption")

        # @return [CurrencyAmount]
        attribute(:charge, CurrencyAmount, from: "Charge")
      end
    end
  end
end
