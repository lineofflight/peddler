# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # The Selling Partner API for Action Items
    #
    # The Selling Partner API for Action Items enables you to discover and inspect action items surfaced by Amazon,
    # including recommendations, issues, and tasks.
    #
    # https://github.com/amzn/selling-partner-api-models/blob/main/models/action-items-api-model/actionItems_2026-06-01.json
    module ActionItems20260601
      # Typed models of successful responses, by native operation key. Shareable, so that any Ractor can read it.
      PARSERS = Ractor.make_shareable({
        "action_items_2026_06_01.dismiss_action_item" => -> { DismissActionItemResponse },
        "action_items_2026_06_01.get_action_item" => -> { GetActionItemResponse },
        "action_items_2026_06_01.list_action_items" => -> { ListActionItemsResponse },
      })
    end
  end
end
