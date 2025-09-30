# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/fulfillment_inbound_v0/amount"

module Peddler
  module Types
    module FulfillmentInboundV0
      # The fees for Amazon to prep goods for shipment.
      AmazonPrepFeesDetails = Structure.new do
        # @return [String]
        attribute?(:prep_instruction, String, from: "PrepInstruction")

        # @return [Amount] The fee for Amazon to prepare 1 unit.
        attribute?(:fee_per_unit, Amount, from: "FeePerUnit")
      end
    end
  end
end
