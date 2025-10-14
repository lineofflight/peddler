# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class ShippingV2
      # The value-added services to be added to a shipping service purchase.
      class OneClickShipmentValueAddedServiceDetails < Array
        class << self
          def parse(array)
            new(array.map { |item| OneClickShipmentValueAddedService.parse(item) })
          end
        end
      end
    end
  end
end
