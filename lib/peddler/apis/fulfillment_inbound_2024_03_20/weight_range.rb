# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentInbound20240320
      # The range of weights that are allowed for a package.
      WeightRange = Structure.new do
        # Maximum allowed weight.
        attribute(:maximum, Float, null: false)

        # Minimum allowed weight.
        attribute(:minimum, Float, null: false)

        # Known values: `LB`, `KG`.
        attribute(:unit, String, null: false)
      end
    end
  end
end
