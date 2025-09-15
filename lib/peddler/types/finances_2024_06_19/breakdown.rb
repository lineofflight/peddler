# frozen_string_literal: true

require "peddler/types/finances_2024_06_19/currency"

module Peddler
  module Types
    module Finances20240619
      # Breakdown provides details regarding the money movement under the financial transaction. Breakdowns get
      # categorized further into breakdown types, breakdown amounts, and further breakdowns into a hierarchical
      # structure.
      Breakdown = Structure.new do
        # @return [String] The type of charge.
        attribute(:breakdown_type, String, from: "breakdownType")

        # @return [Currency] The amount of the charge.
        attribute(:breakdown_amount, Currency, from: "breakdownAmount")

        # @return [Array<Breakdown>] A list of breakdowns that detail how the total amount is calculated for the
        # transaction.
        attribute(:breakdowns, [Breakdown])
      end
    end
  end
end
