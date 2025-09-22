# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # The weight of a package.
      Weight = Structure.new do
        # @return [String]
        attribute(:unit, String)

        # @return [Float] Value of a weight.
        attribute(:value, Float)
      end
    end
  end
end
