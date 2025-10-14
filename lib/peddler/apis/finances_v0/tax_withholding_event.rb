# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FinancesV0
      # A TaxWithholding event on seller's account.
      TaxWithholdingEvent = Structure.new do
        # @return [Money] The amount which tax was withheld against.
        attribute?(:base_amount, Money, from: "BaseAmount")

        # @return [String] The date and time when the financial event was posted.
        attribute?(:posted_date, String, from: "PostedDate")

        # @return [TaxWithholdingPeriod] Time period for which tax is withheld.
        attribute?(:tax_withholding_period, TaxWithholdingPeriod, from: "TaxWithholdingPeriod")

        # @return [Money] The amount of the tax withholding deducted from seller's account.
        attribute?(:withheld_amount, Money, from: "WithheldAmount")
      end
    end
  end
end
