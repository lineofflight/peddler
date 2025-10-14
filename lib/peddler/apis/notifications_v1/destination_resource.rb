# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class NotificationsV1
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
