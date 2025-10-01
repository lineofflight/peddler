# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/fulfillment_inbound_2024_03_20/weight_range"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # The requirements for a box in the packing option.
      BoxRequirements = Structure.new do
        # @return [WeightRange]
        attribute(:weight, WeightRange)
      end
    end
  end
end
