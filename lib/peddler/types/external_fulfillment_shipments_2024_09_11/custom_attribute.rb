# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module ExternalFulfillmentShipments20240911
      # A custom attribute that is loosely typed, modeled through a key-value pair and its data type.
      CustomAttribute = Structure.new do
        # @return [String] The key of the custom attribute. Must be unique.
        attribute?(:key, String)

        # @return [String]
        attribute?(:type, String)

        # @return [String] The value of the custom attribute.
        attribute?(:value, String)
      end
    end
  end
end
