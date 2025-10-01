# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/notifications_v1/error"
require "peddler/types/notifications_v1/subscription"

module Peddler
  module Types
    module NotificationsV1
      # The response schema for the `createSubscription` operation.
      CreateSubscriptionResponse = Structure.new do
        # @return [Array<Error>] One or more unexpected errors occurred during the `createSubscription` operation.
        attribute?(:errors, [Error])

        # @return [Subscription] The payload for the `createSubscription` operation.
        attribute?(:payload, Subscription)
      end
    end
  end
end
