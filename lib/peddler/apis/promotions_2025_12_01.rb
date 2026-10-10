# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # The Selling Partner API for Promotions
    #
    # The Selling Partner API for Promotions enables selling partners to create and manage promotions.
    #
    # https://github.com/amzn/selling-partner-api-models/blob/main/models/promotions-api-model/promotions_2025-12-01.json
    module Promotions20251201
      # Typed models of successful responses, by native operation key. Shareable, so that any Ractor can read it.
      PARSERS = Ractor.make_shareable({
        "promotions_2025_12_01.get_promotion" => -> { GetPromotionResponse },
        "promotions_2025_12_01.get_selection" => -> { GetSelectionResponse },
        "promotions_2025_12_01.search_promotions" => -> { SearchPromotionsResponse },
      })
    end
  end
end
