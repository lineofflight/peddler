# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # Selling Partner API for Finances
    #
    # The Selling Partner API for Finances provides financial information that is relevant to a seller's business. You
    # can obtain financial events for a given order, financial event group, or date range without having to wait until a
    # statement period closes. You can also obtain financial event groups for a given date range.
    #
    # https://github.com/amzn/selling-partner-api-models/blob/main/models/finances-api-model/financesV0.json
    module FinancesV0
      # Typed models of successful responses, by native operation key. Shareable, so that any Ractor can read it.
      PARSERS = Ractor.make_shareable({
        "finances_v0.list_financial_event_groups" => -> { ListFinancialEventGroupsResponse },
        "finances_v0.list_financial_events" => -> { ListFinancialEventsResponse },
        "finances_v0.list_financial_events_by_group_id" => -> { ListFinancialEventsResponse },
        "finances_v0.list_financial_events_by_order_id" => -> { ListFinancialEventsResponse },
      })
    end
  end
end
