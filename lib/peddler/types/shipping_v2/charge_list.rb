# frozen_string_literal: true

require "peddler/types/shipping_v2/charge_component"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ShippingV2
      # A list of charges based on the shipping service charges applied on a package.
      class ChargeList < Array
        class << self
          def parse(array)
            new(array.map { |item| ChargeComponent.parse(item) })
          end
        end
      end
    end
  end
end
