# frozen_string_literal: true

require "peddler/types/merchant_fulfillment_v0/shipping_service"

module Peddler
  module Types
    module MerchantFulfillmentV0
      # A list of shipping services offers.
      class ShippingServiceList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| ShippingService.parse(item) })
          end
        end
      end
    end
  end
end
