# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/money"
require "structure"

module Peddler
  module Types
    module Finances20240619
      # Breakdown provides details regarding the money movement under the financial transaction. Breakdowns get
      # categorized further into breakdown types, breakdown amounts, and further breakdowns into a hierarchical
      # structure.
      Breakdown = Structure.new do
        # @return [Money] The amount of the charge.
        attribute?(:breakdown_amount, Money, from: "breakdownAmount")

        # @return [String] The type of charge.
        attribute?(:breakdown_type, String, from: "breakdownType")

        # @return [Array<self>] A list of breakdowns that detail how the total amount is calculated for the transaction.
        attribute?(:breakdowns, [:self])
      end
    end
  end
end
