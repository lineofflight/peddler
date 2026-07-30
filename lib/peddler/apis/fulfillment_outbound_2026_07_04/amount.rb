# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20260704
      # A quantity based on the specified unit of measurement.
      Amount = Structure.new do
        # @return [String] The amount of a product in the associated unit of measurement.
        attribute(:value, String, null: false)

        # @return [String] The unit of measure for the amount. Possible values: `EACHES`.
        attribute?(:unit, String)
      end
    end
  end
end
