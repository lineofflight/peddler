# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/notifications_v1/destination_resource_specification"

module Peddler
  module Types
    module NotificationsV1
      # The request schema for the `createDestination` operation.
      CreateDestinationRequest = Structure.new do
        # @return [DestinationResourceSpecification] The information required to create a destination resource.
        # Applications should use one resource type (sqs or eventBridge) per destination.
        attribute(:resource_specification, DestinationResourceSpecification, from: "resourceSpecification")

        # @return [String] A developer-defined name to help identify this destination.
        attribute(:name, String)
      end
    end
  end
end
