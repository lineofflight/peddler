# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentOutbound20260704
      # The weight.
      Weight = Structure.new do
        # The unit of weight. Possible values: `KG`, `KILOGRAMS`, `LB`, `POUNDS`.
        attribute(:unit, String, null: false)

        # The weight value.
        attribute(:value, String, null: false)
      end
    end
  end
end
