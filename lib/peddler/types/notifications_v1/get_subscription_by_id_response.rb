# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/notifications_v1/error"
require "peddler/types/notifications_v1/subscription"

module Peddler
  module Types
    module NotificationsV1
      # The response schema for the `getSubscriptionById` operation.
      GetSubscriptionByIdResponse = Structure.new do
        # @return [Array<Error>] An unexpected condition occurred during the `getSubscriptionById` operation.
        attribute?(:errors, [Error])

        # @return [Subscription] The payload for the `getSubscriptionById` operation.
        attribute?(:payload, Subscription)
      end
    end
  end
end
