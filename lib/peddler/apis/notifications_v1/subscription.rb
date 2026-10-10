# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module NotificationsV1
      # Information about the subscription.
      Subscription = Structure.new do
        # The identifier for the destination where notifications will be delivered.
        attribute(:destination_id, String, null: false, from: "destinationId")

        # The version of the payload object to be used in the notification.
        attribute(:payload_version, String, null: false, from: "payloadVersion")

        # The subscription identifier generated when the subscription is created.
        attribute(:subscription_id, String, null: false, from: "subscriptionId")

        attribute?(:processing_directive, ProcessingDirective, from: "processingDirective")
      end
    end
  end
end
