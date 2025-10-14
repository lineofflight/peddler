# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FinancesV0
      # A payment instrument.
      ChargeInstrument = Structure.new do
        # @return [Money] The amount charged to this charge instrument.
        attribute?(:amount, Money, from: "Amount")

        # @return [String] A short description of the charge instrument.
        attribute?(:description, String, from: "Description")

        # @return [String] The account tail (trailing digits) of the charge instrument.
        attribute?(:tail, String, from: "Tail")
      end
    end
  end
end
