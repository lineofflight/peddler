# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class MerchantFulfillmentV0
      # A list of temporarily unavailable carriers.
      class TemporarilyUnavailableCarrierList < Array
        class << self
          def parse(array)
            new(array.map { |item| TemporarilyUnavailableCarrier.parse(item) })
          end
        end
      end
    end
  end
end
