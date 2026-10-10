# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShippingV2
      # Attribute Properties required by carrier
      CarrierAccountAttribute = Structure.new do
        # Attribute Name .
        attribute?(:attribute_name, String, from: "attributeName")

        # Property Group.
        attribute?(:property_group, String, from: "propertyGroup")

        # Value .
        attribute?(:value, String)
      end
    end
  end
end
