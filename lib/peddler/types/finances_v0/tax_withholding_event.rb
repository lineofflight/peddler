# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/money"
require "peddler/types/finances_v0/tax_withholding_period"

module Peddler
  module Types
    module FinancesV0
      # A TaxWithholding event on seller's account.
      TaxWithholdingEvent = Structure.new do
        # @return [String] The date and time when the financial event was posted.
        attribute?(:posted_date, String, from: "PostedDate")

        # @return [Money] The amount which tax was withheld against.
        attribute?(:base_amount, Money, from: "BaseAmount")

        # @return [Money] The amount of the tax withholding deducted from seller's account.
        attribute?(:withheld_amount, Money, from: "WithheldAmount")

        # @return [TaxWithholdingPeriod] Time period for which tax is withheld.
        attribute?(:tax_withholding_period, TaxWithholdingPeriod, from: "TaxWithholdingPeriod")
      end
    end
  end
end
