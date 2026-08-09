# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class NotificationsV1
      # The response schema for the `getSubscriptions` operation.
      GetSubscriptionsResponse = Structure.new do
        # @return [Array<Error>] One or more unexpected errors occurred during the `getSubscriptions` operation.
        attribute?(:errors, [Error])

        # @return [GetSubscriptionsPayload] The payload for the `getSubscriptions` operation.
        attribute?(:payload, GetSubscriptionsPayload)
      end
    end
  end
end
