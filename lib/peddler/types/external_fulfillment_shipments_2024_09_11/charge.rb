# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/external_fulfillment_shipments_2024_09_11/charge_breakup"
require "peddler/types/external_fulfillment_shipments_2024_09_11/tax"

module Peddler
  module Types
    module ExternalFulfillmentShipments20240911
      # A shipment's charge with relevant tax information.
      Charge = Structure.new do
        # @return [ChargeBreakup] The charge value before taxes.
        attribute(:base_charge, ChargeBreakup, from: "baseCharge")

        # @return [String] The type of charge.
        attribute(:charge_type, String, from: "chargeType")

        # @return [ChargeBreakup] The total charge, including the base charge and taxes.
        attribute(:total_charge, ChargeBreakup, from: "totalCharge")

        # @return [Tax] The sum of all taxes.
        attribute(:total_tax, Tax, from: "totalTax")

        # @return [Array<Tax>] The tax charge details.
        attribute?(:tax_breakup, [Tax], from: "taxBreakup")
      end
    end
  end
end
