# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/notifications_v1/sqs_resource"
require "peddler/types/notifications_v1/event_bridge_resource_specification"

module Peddler
  module Types
    module NotificationsV1
      # The information required to create a destination resource. Applications should use one resource type (sqs or
      # eventBridge) per destination.
      DestinationResourceSpecification = Structure.new do
        # @return [SqsResource] The information required to create an Amazon Simple Queue Service (SQS) queue
        # destination.
        attribute?(:sqs, SqsResource)

        # @return [EventBridgeResourceSpecification] The information required to create an Amazon EventBridge
        # destination.
        attribute?(:event_bridge, EventBridgeResourceSpecification, from: "eventBridge")
      end
    end
  end
end
