# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ExternalFulfillmentShipments20240911
      # A shipment's charge with relevant tax information.
      Charge = Structure.new do
        # The charge value before taxes.
        attribute(:base_charge, ChargeBreakup, null: false, from: "baseCharge")

        # The type of charge. Known values: `product`, `shipping`, `gift_wrap`, `total`, `other`.
        attribute(:charge_type, String, null: false, from: "chargeType")

        # The total charge, including the base charge and taxes.
        attribute(:total_charge, ChargeBreakup, null: false, from: "totalCharge")

        # The sum of all taxes.
        attribute(:total_tax, Tax, null: false, from: "totalTax")

        # The tax charge details.
        attribute?(:tax_breakup, [Tax], from: "taxBreakup")
      end
    end
  end
end
