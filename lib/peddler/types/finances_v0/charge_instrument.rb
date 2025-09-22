# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/money"

module Peddler
  module Types
    module FinancesV0
      # A payment instrument.
      ChargeInstrument = Structure.new do
        # @return [String] A short description of the charge instrument.
        attribute(:description, String, from: "Description")

        # @return [String] The account tail (trailing digits) of the charge instrument.
        attribute(:tail, String, from: "Tail")

        # @return [Types::Money] The amount charged to this charge instrument.
        attribute(:amount, Types::Money, from: "Amount")
      end
    end
  end
end
