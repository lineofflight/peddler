# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/fulfillment_inbound_v0/amount"

module Peddler
  module Types
    module FulfillmentInboundV0
      # The fees for Amazon to prep goods for shipment.
      AmazonPrepFeesDetails = Structure.new do
        # @return [Amount] The fee for Amazon to prepare 1 unit.
        attribute?(:fee_per_unit, Amount, from: "FeePerUnit")

        # @return [String]
        attribute?(:prep_instruction, String, from: "PrepInstruction")
      end
    end
  end
end
