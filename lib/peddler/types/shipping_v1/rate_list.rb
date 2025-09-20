# frozen_string_literal: true

require "peddler/types/shipping_v1/rate"

module Peddler
  module Types
    module ShippingV1
      # A list of all the available rates that can be used to send the shipment.
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
