# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/fulfillment_inbound_v0/amount"

module Peddler
  module Types
    module FulfillmentInboundV0
      # The manual processing fee per unit and total fee for a shipment.
      BoxContentsFeeDetails = Structure.new do
        # @return [Amount] The manual processing fee per unit.
        attribute?(:fee_per_unit, Amount, from: "FeePerUnit")

        # @return [Amount] The total manual processing fee for the shipment.
        attribute?(:total_fee, Amount, from: "TotalFee")

        # @return [Integer] The number of units to ship.
        attribute?(:total_units, Integer, from: "TotalUnits")
      end
    end
  end
end
