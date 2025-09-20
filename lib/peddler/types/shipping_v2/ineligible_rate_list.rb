# frozen_string_literal: true

require "peddler/types/shipping_v2/ineligible_rate"

module Peddler
  module Types
    module ShippingV2
      # A list of ineligible shipping service offerings.
      class IneligibleRateList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| IneligibleRate.parse(item) })
          end
        end
      end
    end
  end
end
