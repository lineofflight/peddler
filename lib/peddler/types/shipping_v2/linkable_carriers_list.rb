# frozen_string_literal: true

require "peddler/types/shipping_v2/linkable_carrier"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ShippingV2
      # A list of LinkableCarrier
      class LinkableCarriersList < Array
        class << self
          def parse(array)
            new(array.map { |item| LinkableCarrier.parse(item) })
          end
        end
      end
    end
  end
end
