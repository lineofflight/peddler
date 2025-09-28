# frozen_string_literal: true

require "peddler/types/merchant_fulfillment_v0/available_carrier_will_pick_up_option"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module MerchantFulfillmentV0
      # List of available carrier pickup options.
      class AvailableCarrierWillPickUpOptionsList < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| AvailableCarrierWillPickUpOption.parse(item) }) : new
          end
        end
      end
    end
  end
end
