# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module NotificationsV1
      # The response schema for the `getSubscription` operation.
      GetSubscriptionResponse = Structure.new do
        # One or more unexpected errors occurred during the `getSubscription` operation.
        attribute?(:errors, [Error])

        # The payload for the `getSubscription` operation.
        attribute?(:payload, Subscription)
      end
    end
  end
end
