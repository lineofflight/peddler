# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class MerchantFulfillmentV0
      # List of services that are for some reason unavailable for this request
      class RejectedShippingServiceList < Array
        class << self
          def parse(array)
            new(array.map { |item| RejectedShippingService.parse(item) })
          end
        end
      end
    end
  end
end
