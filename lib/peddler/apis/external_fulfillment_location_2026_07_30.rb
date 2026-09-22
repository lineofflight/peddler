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
    class ExternalFulfillmentLocation20260730 < API
      # Creates a sandbox location and merchant in the test environment. This operation is available only in the sandbox
      # environment and is used for onboarding test locations. Idempotency is ensured on locationName.
      #
      # @note This operation can make a dynamic sandbox call.
      # @param body [Hash] The request body for creating a sandbox location.
      # @return [Peddler::Response] The API response
      def create_sandbox_location(body)
        must_sandbox!

        path = "/externalFulfillment/2026-07-30/location"
        parser = -> { CreateSandboxLocationResponse }
        post(path, body:, parser:)
      end
    end
  end
end
