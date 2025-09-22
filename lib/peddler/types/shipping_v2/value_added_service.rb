# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/money"

module Peddler
  module Types
    module ShippingV2
      # A value-added service available for purchase with a shipment service offering.
      ValueAddedService = Structure.new do
        # @return [String] The identifier for the value-added service.
        attribute(:id, String)

        # @return [String] The name of the value-added service.
        attribute(:name, String)

        # @return [Types::Money] The cost of the value-added service.
        attribute(:cost, Types::Money)
      end
    end
  end
end
