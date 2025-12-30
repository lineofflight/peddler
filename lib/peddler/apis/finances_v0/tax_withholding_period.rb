# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FinancesV0
      # The period during which tax withholding on a seller's account is calculated.
      TaxWithholdingPeriod = Structure.new do
        # @return [String] End of the time range.
        attribute?(:end_date, String, from: "EndDate")

        # @return [String] Start of the time range.
        attribute?(:start_date, String, from: "StartDate")
      end
    end
  end
end
