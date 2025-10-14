# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class MerchantFulfillmentV0
      # The available shipping service options.
      AvailableShippingServiceOptions = Structure.new do
        # @return [Array<AvailableCarrierWillPickUpOption>]
        attribute(:available_carrier_will_pick_up_options, [AvailableCarrierWillPickUpOption], from: "AvailableCarrierWillPickUpOptions")

        # @return [Array<AvailableDeliveryExperienceOption>]
        attribute(:available_delivery_experience_options, [AvailableDeliveryExperienceOption], from: "AvailableDeliveryExperienceOptions")
      end
    end
  end
end
