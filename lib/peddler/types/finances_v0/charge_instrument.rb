# frozen_string_literal: true

require "peddler/types/finances_v0/currency"

module Peddler
  module Types
    module FinancesV0
      # A payment instrument.
      ChargeInstrument = Structure.new do
        # @return [String] A short description of the charge instrument.
        attribute(:description, String, from: "Description")

        # @return [String] The account tail (trailing digits) of the charge instrument.
        attribute(:tail, String, from: "Tail")

        # @return [Currency] The amount charged to this charge instrument.
        attribute(:amount, Currency, from: "Amount")
      end
    end
  end
end
