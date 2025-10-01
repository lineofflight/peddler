# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/money"
require "structure"

module Peddler
  module Types
    module ShippingV2
      # A value-added service available for purchase with a shipment service offering.
      ValueAddedService = Structure.new do
        # @return [Money] The cost of the value-added service.
        attribute(:cost, Money)

        # @return [String] The identifier for the value-added service.
        attribute(:id, String)

        # @return [String] The name of the value-added service.
        attribute(:name, String)
      end
    end
  end
end
