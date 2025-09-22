# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/money"

module Peddler
  module Types
    module MerchantFulfillmentV0
      # The available delivery confirmation options, and the fee charged, if any.
      AvailableDeliveryExperienceOption = Structure.new do
        # @return [String]
        attribute(:delivery_experience_option, String, from: "DeliveryExperienceOption")

        # @return [Types::Money]
        attribute(:charge, Types::Money, from: "Charge")
      end
    end
  end
end
