# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # Selling Partner API for Data Kiosk
    #
    # The Selling Partner API for Data Kiosk lets you submit GraphQL queries from a variety of schemas to help selling
    # partners manage their businesses.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/data-kiosk-api-model/dataKiosk_2023-11-15.json
    module DataKiosk20231115
      # Typed models of successful responses, by native operation key. Shareable, so that any Ractor can read it.
      PARSERS = Ractor.make_shareable({
        "data_kiosk_2023_11_15.create_query" => -> { CreateQueryResponse },
        "data_kiosk_2023_11_15.get_document" => -> { GetDocumentResponse },
        "data_kiosk_2023_11_15.get_queries" => -> { GetQueriesResponse },
        "data_kiosk_2023_11_15.get_query" => -> { Query },
      })
    end
  end
end
