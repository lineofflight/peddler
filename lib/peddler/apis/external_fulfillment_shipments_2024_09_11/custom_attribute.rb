# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ExternalFulfillmentShipments20240911
      # A custom attribute that is loosely typed, modeled through a key-value pair and its data type.
      CustomAttribute = Structure.new do
        # The attribute key.
        attribute?(:key, String)

        # Known values: `STRING`, `BOOLEAN`, `INTEGER`, `DOUBLE`, `JSON_STRING`.
        attribute?(:type, String)

        # The attribute value.
        attribute?(:value, String)
      end
    end
  end
end
