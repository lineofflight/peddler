# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class ShippingV2
      # A list of ineligible shipping service offerings.
      class IneligibleRateList < Array
        class << self
          def parse(array)
            new(array.map { |item| IneligibleRate.parse(item) })
          end
        end
      end
    end
  end
end
