# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/merchant_fulfillment_v0/available_carrier_will_pick_up_option"
require "peddler/types/merchant_fulfillment_v0/available_delivery_experience_option"

module Peddler
  module Types
    module MerchantFulfillmentV0
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
