# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # Selling Partner API for Replenishment
    #
    # The Selling Partner API for Replenishment (Replenishment API) provides programmatic access to replenishment
    # program metrics and offers. These programs provide recurring delivery of any replenishable item at a frequency
    # chosen by the customer.
    #
    # The Replenishment API is available worldwide wherever Amazon Subscribe & Save is available or is supported. The
    # API is available to vendors and FBA selling partners.
    #
    # https://github.com/amzn/selling-partner-api-models/blob/main/models/replenishment-api-model/replenishment-2022-11-07.json
    module Replenishment20221107
      # Typed models of successful responses, by native operation key. Shareable, so that any Ractor can read it.
      PARSERS = Ractor.make_shareable({
        "replenishment_2022_11_07.get_selling_partner_metrics" => -> { GetSellingPartnerMetricsResponse },
        "replenishment_2022_11_07.list_offer_metrics" => -> { ListOfferMetricsResponse },
        "replenishment_2022_11_07.list_offers" => -> { ListOffersResponse },
      })
    end
  end
end
