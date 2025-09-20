# frozen_string_literal: true

require "peddler/types/shipping_v2/rate"

module Peddler
  module Types
    module ShippingV2
      # A list of eligible shipping service offerings.
      class RateList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| Rate.parse(item) })
          end
        end
      end
    end
  end
end
