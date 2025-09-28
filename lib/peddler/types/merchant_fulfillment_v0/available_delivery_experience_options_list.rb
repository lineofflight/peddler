# frozen_string_literal: true

require "peddler/types/merchant_fulfillment_v0/available_delivery_experience_option"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module MerchantFulfillmentV0
      # List of available delivery experience options.
      class AvailableDeliveryExperienceOptionsList < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| AvailableDeliveryExperienceOption.parse(item) }) : new
          end
        end
      end
    end
  end
end
