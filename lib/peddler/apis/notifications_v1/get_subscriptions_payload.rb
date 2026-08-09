# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class NotificationsV1
      # The payload for the `getSubscriptions` operation.
      GetSubscriptionsPayload = Structure.new do
        # @return [String] A token that you can use to retrieve the next page of results. When this field is not empty,
        #   pass its value in the `nextToken` query parameter of the next request.
        attribute?(:next_token, String, from: "nextToken")

        # @return [Array<Subscription>] A list of subscriptions.
        attribute?(:subscriptions, [Subscription])
      end
    end
  end
end
