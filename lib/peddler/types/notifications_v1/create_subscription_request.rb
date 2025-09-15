# frozen_string_literal: true

require "peddler/types/notifications_v1/processing_directive"

module Peddler
  module Types
    module NotificationsV1
      # The request schema for the `createSubscription` operation.
      CreateSubscriptionRequest = Structure.new do
        # @return [String] The version of the payload object to be used in the notification.
        attribute(:payload_version, String, from: "payloadVersion")

        # @return [String] The identifier for the destination where notifications will be delivered.
        attribute(:destination_id, String, from: "destinationId")

        # @return [ProcessingDirective]
        attribute(:processing_directive, ProcessingDirective, from: "processingDirective")
      end
    end
  end
end
