# frozen_string_literal: true

require "peddler/types/shipping_v2/currency"

module Peddler
  module Types
    module ShippingV2
      # A value-added service available for purchase with a shipment service offering.
      ValueAddedService = Structure.new do
        # @return [String] The identifier for the value-added service.
        attribute(:id, String)

        # @return [String] The name of the value-added service.
        attribute(:name, String)

        # @return [Currency] The cost of the value-added service.
        attribute(:cost, Currency)
      end
    end
  end
end
