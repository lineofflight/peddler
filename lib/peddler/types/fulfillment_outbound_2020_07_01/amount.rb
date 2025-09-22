# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # A quantity based on unit of measure.
      Amount = Structure.new do
        # @return [String] The unit of measure for the amount.
        attribute(:unit_of_measure, String, from: "unitOfMeasure")

        # @return [String] The amount of a product in the associated unit of measure.
        attribute(:value, String)
      end
    end
  end
end
