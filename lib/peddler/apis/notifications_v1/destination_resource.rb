# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module NotificationsV1
      # The destination resource types.
      DestinationResource = Structure.new do
        # An Amazon EventBridge destination.
        attribute?(:event_bridge, EventBridgeResource, from: "eventBridge")

        # An Amazon Simple Queue Service (SQS) queue destination.
        attribute?(:sqs, SqsResource)
      end
    end
  end
end
