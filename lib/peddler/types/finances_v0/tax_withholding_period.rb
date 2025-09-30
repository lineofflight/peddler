# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module FinancesV0
      # Period which taxwithholding on seller's account is calculated.
      TaxWithholdingPeriod = Structure.new do
        # @return [String] Start of the time range.
        attribute?(:start_date, String, from: "StartDate")

        # @return [String] End of the time range.
        attribute?(:end_date, String, from: "EndDate")
      end
    end
  end
end
