# frozen_string_literal: true

require "peddler/types/shipping_v2/ineligible_rate"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ShippingV2
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
