# frozen_string_literal: true

require "peddler/types/merchant_fulfillment_v0/rejected_shipping_service"

module Peddler
  module Types
    module MerchantFulfillmentV0
      # List of services that are for some reason unavailable for this request
      class RejectedShippingServiceList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| RejectedShippingService.parse(item) })
          end
        end
      end
    end
  end
end
