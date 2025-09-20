# frozen_string_literal: true

require "peddler/types/shipping_v2/linkable_carrier"

module Peddler
  module Types
    module ShippingV2
      # A list of LinkableCarrier
      class LinkableCarriersList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| LinkableCarrier.parse(item) })
          end
        end
      end
    end
  end
end
