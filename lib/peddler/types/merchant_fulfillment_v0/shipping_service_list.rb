# frozen_string_literal: true

require "peddler/types/merchant_fulfillment_v0/shipping_service"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module MerchantFulfillmentV0
      # A list of shipping services offers.
      class ShippingServiceList < Array
        class << self
          def parse(array)
            new(array.map { |item| ShippingService.parse(item) })
          end
        end
      end
    end
  end
end
