# frozen_string_literal: true

require "peddler/types/shipping_v2/rate"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ShippingV2
      # A list of eligible shipping service offerings.
      class RateList < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| Rate.parse(item) }) : new
          end
        end
      end
    end
  end
end
