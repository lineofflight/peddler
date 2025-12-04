# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Finances20240619
      # Details about the movement of money in the financial transaction. Breakdowns are further categorized into
      # breakdown types, breakdown amounts, and further breakdowns.
      Breakdown = Structure.new do
        # @return [Money] The monetary amount of the charge.
        attribute?(:breakdown_amount, Money, from: "breakdownAmount")

        # @return [String] The type of charge.
        attribute?(:breakdown_type, String, from: "breakdownType")

        # @return [Array<self>] A list of breakdowns that detail how the total amount is calculated for the transaction.
        attribute?(:breakdowns, [:self])
      end
    end
  end
end
