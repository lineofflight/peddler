# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class NotificationsV1
      # The response schema for the `sendTestNotification` operation.
      SendTestNotificationResponse = Structure.new do
        # @return [Array<Error>] One or more unexpected errors occurred during the `sendTestNotification` operation.
        attribute?(:errors, [Error])

        # @return [String] The payload for the `sendTestNotification` operation.
        attribute?(:payload, String)
      end
    end
  end
end
