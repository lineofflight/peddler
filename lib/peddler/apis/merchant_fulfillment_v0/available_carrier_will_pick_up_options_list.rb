# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class MerchantFulfillmentV0
      # List of available carrier pickup options.
      class AvailableCarrierWillPickUpOptionsList < Array
        class << self
          def parse(array)
            new(array.map { |item| AvailableCarrierWillPickUpOption.parse(item) })
          end
        end
      end
    end
  end
end
