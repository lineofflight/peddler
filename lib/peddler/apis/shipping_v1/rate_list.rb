# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class ShippingV1
      # A list of all the available rates that can be used to send the shipment.
      class RateList < Array
        class << self
          def parse(array)
            new(array.map { |item| Rate.parse(item) })
          end
        end
      end
    end
  end
end
