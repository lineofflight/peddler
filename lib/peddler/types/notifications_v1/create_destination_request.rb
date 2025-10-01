# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/notifications_v1/destination_resource_specification"

module Peddler
  module Types
    module NotificationsV1
      # The request schema for the `createDestination` operation.
      CreateDestinationRequest = Structure.new do
        # @return [String] A developer-defined name to help identify this destination.
        attribute(:name, String)

        # @return [DestinationResourceSpecification] The information required to create a destination resource.
        # Applications should use one resource type (sqs or eventBridge) per destination.
        attribute(:resource_specification, DestinationResourceSpecification, from: "resourceSpecification")
      end
    end
  end
end
