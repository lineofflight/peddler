# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module NotificationsV1
      # The response schema for the `createSubscription` operation.
      CreateSubscriptionResponse = Structure.new do
        # One or more unexpected errors occurred during the `createSubscription` operation.
        attribute?(:errors, [Error])

        # The payload for the `createSubscription` operation.
        attribute?(:payload, Subscription)
      end
    end
  end
end
