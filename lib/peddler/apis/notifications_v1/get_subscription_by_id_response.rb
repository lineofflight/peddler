# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module NotificationsV1
      # The response schema for the `getSubscriptionById` operation.
      GetSubscriptionByIdResponse = Structure.new do
        # An unexpected condition occurred during the `getSubscriptionById` operation.
        attribute?(:errors, [Error])

        # The payload for the `getSubscriptionById` operation.
        attribute?(:payload, Subscription)
      end
    end
  end
end
