# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ExternalFulfillmentShipments20240911
      # A shipment's charge with relevant tax information.
      Charge = Structure.new do
        # @return [ChargeBreakup] The charge value before taxes.
        attribute(:base_charge, ChargeBreakup, null: false, from: "baseCharge")

        # @return [String] The type of charge.
        attribute(:charge_type, String, null: false, from: "chargeType")

        # @return [ChargeBreakup] The total charge, including the base charge and taxes.
        attribute(:total_charge, ChargeBreakup, null: false, from: "totalCharge")

        # @return [Tax] The sum of all taxes.
        attribute(:total_tax, Tax, null: false, from: "totalTax")

        # @return [Array<Tax>] The tax charge details.
        attribute?(:tax_breakup, [Tax], from: "taxBreakup")
      end
    end
  end
end
