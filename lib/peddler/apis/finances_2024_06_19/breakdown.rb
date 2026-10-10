# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module Finances20240619
      # Details about the movement of money in the financial transaction.
      Breakdown = Structure.new do
        # The monetary amount of the charge.
        attribute?(:breakdown_amount, Money, from: "breakdownAmount")

        # The type of charge.
        attribute?(:breakdown_type, String, from: "breakdownType")

        # A list of breakdowns that detail how the total amount is calculated for the transaction.
        attribute?(:breakdowns, [:self])
      end
    end
  end
end
