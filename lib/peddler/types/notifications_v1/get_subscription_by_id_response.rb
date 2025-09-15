# frozen_string_literal: true

require "peddler/types/notifications_v1/subscription"
require "peddler/types/notifications_v1/error"

module Peddler
  module Types
    module NotificationsV1
      # The response schema for the `getSubscriptionById` operation.
      GetSubscriptionByIdResponse = Structure.new do
        # @return [Subscription] The payload for the `getSubscriptionById` operation.
        attribute(:payload, Subscription)

        # @return [Array<Error>] An unexpected condition occurred during the `getSubscriptionById` operation.
        attribute(:errors, [Error])
      end
    end
  end
end
