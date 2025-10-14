# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # The range of weights that are allowed for a package.
      WeightRange = Structure.new do
        # @return [Float] Maximum allowed weight.
        attribute(:maximum, Float)

        # @return [Float] Minimum allowed weight.
        attribute(:minimum, Float)

        # @return [String]
        attribute(:unit, String)
      end
    end
  end
end
