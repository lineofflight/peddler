# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/notifications_v1/event_bridge_resource"
require "peddler/types/notifications_v1/sqs_resource"

module Peddler
  module Types
    module NotificationsV1
      # The destination resource types.
      DestinationResource = Structure.new do
        # @return [EventBridgeResource] An Amazon EventBridge destination.
        attribute?(:event_bridge, EventBridgeResource, from: "eventBridge")

        # @return [SqsResource] An Amazon Simple Queue Service (SQS) queue destination.
        attribute?(:sqs, SqsResource)
      end
    end
  end
end
