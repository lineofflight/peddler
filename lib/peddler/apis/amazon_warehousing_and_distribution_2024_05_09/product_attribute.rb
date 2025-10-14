# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AmazonWarehousingAndDistribution20240509
      # Product instance attribute that is not described at the SKU level in the catalog.
      ProductAttribute = Structure.new do
        # @return [String] Product attribute name.
        attribute?(:name, String)

        # @return [String] Product attribute value.
        attribute?(:value, String)
      end
    end
  end
end
