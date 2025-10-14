# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class NotificationsV1
      # The request schema for the `createSubscription` operation.
      CreateSubscriptionRequest = Structure.new do
        # @return [String] The identifier for the destination where notifications will be delivered.
        attribute(:destination_id, String, from: "destinationId")

        # @return [String] The version of the payload object to be used in the notification.
        attribute(:payload_version, String, from: "payloadVersion")

        # @return [ProcessingDirective]
        attribute?(:processing_directive, ProcessingDirective, from: "processingDirective")
      end
    end
  end
end
