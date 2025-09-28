# frozen_string_literal: true

require "peddler/types/shipping_v1/rate"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ShippingV1
      # A list of all the available rates that can be used to send the shipment.
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
