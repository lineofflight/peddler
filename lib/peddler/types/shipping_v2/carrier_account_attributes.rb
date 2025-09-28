# frozen_string_literal: true

require "peddler/types/shipping_v2/carrier_account_attribute"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ShippingV2
      # A list of all attributes required by the carrier in order to successfully link the merchant's account
      class CarrierAccountAttributes < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| CarrierAccountAttribute.parse(item) }) : new
          end
        end
      end
    end
  end
end
