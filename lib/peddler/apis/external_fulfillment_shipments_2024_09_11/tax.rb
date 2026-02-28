# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ExternalFulfillmentShipments20240911
      # Information about taxes.
      Tax = Structure.new do
        # @return [ChargeBreakup] Details of individual tax charges.
        attribute(:charge, ChargeBreakup, null: false)

        # @return [String] The rate of the tax.
        attribute?(:rate, String)

        # @return [String] The type of tax.
        attribute?(:type, String)
      end
    end
  end
end
