# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/notifications_v1/event_bridge_resource_specification"
require "peddler/types/notifications_v1/sqs_resource"

module Peddler
  module Types
    module NotificationsV1
      # The information required to create a destination resource. Applications should use one resource type (sqs or
      # eventBridge) per destination.
      DestinationResourceSpecification = Structure.new do
        # @return [EventBridgeResourceSpecification] The information required to create an Amazon EventBridge
        # destination.
        attribute?(:event_bridge, EventBridgeResourceSpecification, from: "eventBridge")

        # @return [SqsResource] The information required to create an Amazon Simple Queue Service (SQS) queue
        # destination.
        attribute?(:sqs, SqsResource)
      end
    end
  end
end
