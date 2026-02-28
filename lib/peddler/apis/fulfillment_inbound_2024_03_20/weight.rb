# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # The weight of a package.
      Weight = Structure.new do
        # @return [String]
        attribute(:unit, String, null: false)

        # @return [Float] Value of a weight.
        attribute(:value, Float, null: false)
      end
    end
  end
end
