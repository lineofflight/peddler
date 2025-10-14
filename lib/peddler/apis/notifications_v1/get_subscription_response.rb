# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class NotificationsV1
      # The response schema for the `getSubscription` operation.
      GetSubscriptionResponse = Structure.new do
        # @return [Array<Error>] One or more unexpected errors occurred during the `getSubscription` operation.
        attribute?(:errors, [Error])

        # @return [Subscription] The payload for the `getSubscription` operation.
        attribute?(:payload, Subscription)
      end
    end
  end
end
