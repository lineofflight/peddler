# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # The Selling Partner API for Amazon External Fulfillment Return Item Processing
    #
    # You can use the Amazon External Fulfillment Return Item Processing API to retrieve, track, and process return
    # items through Amazon's External Fulfillment returns management system.
    #
    # https://github.com/amzn/selling-partner-api-models/blob/main/models/external-fulfillment/externalFulfillmentReturns_2024-09-11.json
    module ExternalFulfillmentReturns20240911
      # Typed models of successful responses, by native operation key. Shareable, so that any Ractor can read it.
      PARSERS = Ractor.make_shareable({
        "external_fulfillment_returns_2024_09_11.get_return" => -> { Return },
        "external_fulfillment_returns_2024_09_11.list_returns" => -> { ReturnsResponse },
      })
    end
  end
end
