# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module FulfillmentInbound20240320
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
