# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module Economics20240315
      # The properties used in economics calculation.
      EconomicsProperty = Structure.new do
        # @return [String] Property name
        attribute?(:property_name, String, null: false, from: "propertyName")

        # @return [String] Property value
        attribute?(:property_value, String, null: false, from: "propertyValue")
      end
    end
  end
end
