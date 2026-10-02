# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # The Selling Partner API for Finances
    #
    # The Selling Partner API for Finances provides financial information relevant to a seller's business. You can
    # obtain financial events for a given order or date range without having to wait until a statement period closes.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/finances-api-model/finances_2024-06-19.json
    module Finances20240619
      # Typed models of successful responses, by native operation key
      PARSERS = {
        "finances_2024_06_19.list_balances" => -> { ListBalancesResponse },
        "finances_2024_06_19.list_summary" => -> { SummaryResponse },
        "finances_2024_06_19.list_transactions" => -> { ListTransactionsResponse },
      }.freeze
    end
  end
end
