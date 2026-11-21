# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FinancesV0
      # A payment instrument.
      ChargeInstrument = Structure.new do
        # The amount charged to this charge instrument.
        attribute?(:amount, Money, from: "Amount")

        # A short description of the charge instrument.
        attribute?(:description, String, from: "Description")

        # The account tail (trailing digits) of the charge instrument.
        attribute?(:tail, String, from: "Tail")
      end
    end
  end
end
