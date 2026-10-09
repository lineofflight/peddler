# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # The Selling Partner API for Transfers.
    #
    # The Selling Partner API for Transfers enables selling partners to retrieve payment methods and initiate payouts
    # for their seller accounts. This API supports the following marketplaces: DE, FR, IT, ES, SE, NL, PL, and BE.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/finances-api-model/transfers_2024-06-01.json
    module Transfers20240601
      # Typed models of successful responses, by native operation key. Shareable, so that any Ractor can read it.
      PARSERS = Ractor.make_shareable({
        "transfers_2024_06_01.get_payment_methods" => -> { GetPaymentMethodsResponse },
        "transfers_2024_06_01.initiate_payout" => -> { InitiatePayoutResponse },
        "transfers_2024_06_01.list_expected_payouts" => -> { ListExpectedPayoutsResponse },
        "transfers_2024_06_01.list_payouts" => -> { ListPayoutsResponse },
      })
    end
  end
end
