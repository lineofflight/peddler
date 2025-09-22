# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/shipping_v2/currency"

module Peddler
  module Types
    module ShippingV2
      # A value-added service to be applied to a shipping service purchase.
      OneClickShipmentValueAddedService = Structure.new do
        # @return [String] The identifier of the selected value-added service.
        attribute(:id, String)

        # @return [Currency]
        attribute(:amount, Currency)
      end
    end
  end
end
