# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Orders20260101
      # Additional requirements needed for cross-border shipping of an order item.
      ItemInternationalShipping = Structure.new do
        # @return [String] Import One-Stop Shop registration number required for EU VAT compliance when shipping from
        #   outside the European Union. Sellers shipping to the EU from outside the EU must provide this IOSS number to
        #   their carrier when Amazon has collected the VAT on the sale.
        attribute?(:ioss_number, String, from: "iossNumber")
      end
    end
  end
end
