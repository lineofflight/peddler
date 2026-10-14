# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class MerchantFulfillmentV0
      # The available delivery confirmation options, and the fee charged, if any.
      AvailableDeliveryExperienceOption = Structure.new do
        # @return [Money]
        attribute(:charge, Money, null: false, from: "Charge")

        # @return [String] Known values: `DeliveryConfirmationWithAdultSignature`, `DeliveryConfirmationWithSignature`,
        #   `DeliveryConfirmationWithoutSignature`, `NoTracking`, `NoPreference`.
        attribute(:delivery_experience_option, String, null: false, from: "DeliveryExperienceOption")
      end
    end
  end
end
