# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20200701
      # A quantity based on unit of measure.
      DeliveryQuantity = Structure.new do
        # @return [String] The amount of a product in the associated unit of measure.
        attribute(:amount, String)

        # @return [String] The unit of measure for the amount.
        attribute(:unit_of_measure, String, from: "unitOfMeasure")
      end
    end
  end
end
