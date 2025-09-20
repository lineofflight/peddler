# frozen_string_literal: true

require "peddler/types/merchant_fulfillment_v0/available_carrier_will_pick_up_option"

module Peddler
  module Types
    module MerchantFulfillmentV0
      # List of available carrier pickup options.
      class AvailableCarrierWillPickUpOptionsList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| AvailableCarrierWillPickUpOption.parse(item) })
          end
        end
      end
    end
  end
end
