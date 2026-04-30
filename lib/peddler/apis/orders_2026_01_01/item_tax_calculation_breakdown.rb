# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Orders20260101
      # Tax calculation breakdowns for an order item.
      ItemTaxCalculationBreakdown = Structure.new do
        # @return [String] The tax reporting scheme applied to this order item.
        #
        # **Possible values**:
        # - `UOSS` (Union one stop shop. The item being purchased is held in the EU for shipment) - `IOSS` (Import one
        #   stop shop. The item being purchased is not held in the EU for shipment)
        attribute?(:reporting_scheme, String, from: "reportingScheme")
      end
    end
  end
end
