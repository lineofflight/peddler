# frozen_string_literal: true

require "peddler/types/shipping_v2/carrier_account_input"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ShippingV2
      # A list of CarrierAccountInput
      class CarrierAccountInputsList < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| CarrierAccountInput.parse(item) }) : new
          end
        end
      end
    end
  end
end
