# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module ShippingV2
      # Attribute Properties required by carrier
      CarrierAccountAttribute = Structure.new do
        # @return [String] Attribute Name .
        attribute?(:attribute_name, String, from: "attributeName")

        # @return [String] Property Group.
        attribute?(:property_group, String, from: "propertyGroup")

        # @return [String] Value .
        attribute?(:value, String)
      end
    end
  end
end
