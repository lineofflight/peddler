# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # The Selling Partner API for Amazon External Fulfillment Location Management
    #
    # You can use the External Fulfillment Location API to manage locations in the sandbox environment for end-to-end
    # testing. This API is available only in the sandbox environment.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/external-fulfillment/externalFulfillmentLocation_2026-07-30.json
    module ExternalFulfillmentLocation20260730
      # Typed models of successful responses, by native operation key. Shareable, so that any Ractor can read it.
      PARSERS = Ractor.make_shareable({
        "external_fulfillment_location_2026_07_30.create_sandbox_location" => -> { CreateSandboxLocationResponse },
      })
    end
  end
end
