# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/external_fulfillment_shipments_2024_09_11/charge_breakup"

module Peddler
  module Types
    module ExternalFulfillmentShipments20240911
      # Information about taxes.
      Tax = Structure.new do
        # @return [ChargeBreakup] Details of individual tax charges.
        attribute(:charge, ChargeBreakup)

        # @return [String] The rate of the tax.
        attribute?(:rate, String)

        # @return [String] The type of tax.
        attribute?(:type, String)
      end
    end
  end
end
