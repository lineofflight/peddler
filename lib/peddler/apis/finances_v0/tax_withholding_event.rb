# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FinancesV0
      # A tax withholding event on a seller's account.
      TaxWithholdingEvent = Structure.new do
        # The amount which tax was withheld against.
        attribute?(:base_amount, Money, from: "BaseAmount")

        # The date and time when the financial event was posted.
        attribute?(:posted_date, String, from: "PostedDate")

        # Time period for which tax is withheld.
        attribute?(:tax_withholding_period, TaxWithholdingPeriod, from: "TaxWithholdingPeriod")

        # The amount of the tax withholding deducted from seller's account.
        attribute?(:withheld_amount, Money, from: "WithheldAmount")
      end
    end
  end
end
