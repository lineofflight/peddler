# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class MerchantFulfillmentV0
      # List of available delivery experience options.
      class AvailableDeliveryExperienceOptionsList < Array
        class << self
          def parse(array)
            new(array.map { |item| AvailableDeliveryExperienceOption.parse(item) })
          end
        end
      end
    end
  end
end
