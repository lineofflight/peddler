# frozen_string_literal: true

require "peddler/types/notifications_v1/error"

module Peddler
  module Types
    module NotificationsV1
      # The response schema for the `deleteSubscriptionById` operation.
      DeleteSubscriptionByIdResponse = Structure.new do
        # @return [Array<Error>] An unexpected condition occurred during the `deleteSubscriptionById` operation.
        attribute(:errors, [Error])
      end
    end
  end
end
