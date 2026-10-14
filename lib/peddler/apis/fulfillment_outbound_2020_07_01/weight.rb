# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20200701
      # The weight.
      Weight = Structure.new do
        # @return [String] The unit of weight. Known values: `KG`, `KILOGRAMS`, `LB`, `POUNDS`.
        attribute(:unit, String, null: false)

        # @return [String] The weight value.
        attribute(:value, String, null: false)
      end
    end
  end
end
