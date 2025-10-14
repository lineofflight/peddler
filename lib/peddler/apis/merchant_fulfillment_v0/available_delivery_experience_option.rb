# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class MerchantFulfillmentV0
      # The available delivery confirmation options, and the fee charged, if any.
      AvailableDeliveryExperienceOption = Structure.new do
        # @return [Money]
        attribute(:charge, Money, from: "Charge")

        # @return [String]
        attribute(:delivery_experience_option, String, from: "DeliveryExperienceOption")
      end
    end
  end
end
