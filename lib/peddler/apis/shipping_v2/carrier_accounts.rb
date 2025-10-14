# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class ShippingV2
      # A list of CarrierAccounts
      class CarrierAccounts < Array
        class << self
          def parse(array)
            new(array.map { |item| CarrierAccount.parse(item) })
          end
        end
      end
    end
  end
end
