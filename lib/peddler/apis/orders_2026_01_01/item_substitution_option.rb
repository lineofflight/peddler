# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module Orders20260101
      # Alternative product that can be substituted for an original order item when it becomes unavailable during
      # fulfillment.
      ItemSubstitutionOption = Structure.new do
        # Amazon Standard Identification Number of the substitute product.
        attribute?(:asin, String)

        # Unit of measure and quantity specifications for the substitute product.
        attribute?(:measurement, Measurement)

        # Number of units of the substitute item to be selected if substitution occurs.
        attribute?(:quantity_ordered, Integer, from: "quantityOrdered")

        # The item's seller stock keeping unit (SKU).
        attribute?(:seller_sku, String, from: "sellerSku")

        # Product name or title of the substitute item as displayed to customers.
        attribute?(:title, String)
      end
    end
  end
end
