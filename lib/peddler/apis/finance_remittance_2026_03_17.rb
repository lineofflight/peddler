# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # The Selling Partner API for Finance Remittance
    #
    # The Selling Partner API for Finance Remittance provides programmatic access to selling partner payment remittance
    # data, including remittance summaries and detailed line items.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/finance-remittance-api-model/financeRemittance-2026-03-17.json
    module FinanceRemittance20260317
      # Typed models of successful responses, by native operation key
      PARSERS = {
        "finance_remittance_2026_03_17.get_remittance" => -> { GetRemittanceResponse },
        "finance_remittance_2026_03_17.get_remittance_headers" => -> { GetRemittancesResponse },
      }.freeze
    end
  end
end
