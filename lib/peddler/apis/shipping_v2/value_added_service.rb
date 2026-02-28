# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV2
      # A value-added service available for purchase with a shipment service offering.
      ValueAddedService = Structure.new do
        # @return [Money] The cost of the value-added service.
        attribute(:cost, Money, null: false)

        # @return [String] The identifier for the value-added service.
        attribute(:id, String, null: false)

        # @return [String] The name of the value-added service.
        attribute(:name, String, null: false)
      end
    end
  end
end
