# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class MerchantFulfillmentV0
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
