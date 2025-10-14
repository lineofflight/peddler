# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class ShippingV2
      # A list of all attributes required by the carrier in order to successfully link the merchant's account
      class CarrierAccountAttributes < Array
        class << self
          def parse(array)
            new(array.map { |item| CarrierAccountAttribute.parse(item) })
          end
        end
      end
    end
  end
end
