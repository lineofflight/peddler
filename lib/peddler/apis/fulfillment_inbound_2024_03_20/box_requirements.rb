# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # The requirements for a box in the packing option.
      BoxRequirements = Structure.new do
        # @return [WeightRange]
        attribute(:weight, WeightRange, null: false)
      end
    end
  end
end
