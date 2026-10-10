# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShippingV2
      # A value-added service available for purchase with a shipment service offering.
      ValueAddedService = Structure.new do
        # The cost of the value-added service.
        attribute(:cost, Money, null: false)

        # The identifier for the value-added service.
        attribute(:id, String, null: false)

        # The name of the value-added service.
        attribute(:name, String, null: false)
      end
    end
  end
end
