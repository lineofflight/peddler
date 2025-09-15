# frozen_string_literal: true

require "peddler/types/notifications_v1/subscription"
require "peddler/types/notifications_v1/error"

module Peddler
  module Types
    module NotificationsV1
      # The response schema for the `createSubscription` operation.
      CreateSubscriptionResponse = Structure.new do
        # @return [Subscription] The payload for the `createSubscription` operation.
        attribute(:payload, Subscription)

        # @return [Array<Error>] One or more unexpected errors occurred during the `createSubscription` operation.
        attribute(:errors, [Error])
      end
    end
  end
end
