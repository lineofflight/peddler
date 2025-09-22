# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/notifications_v1/destination_resource"

module Peddler
  module Types
    module NotificationsV1
      # Information about the destination created when you call the `createDestination` operation.
      Destination = Structure.new do
        # @return [String] The developer-defined name for this destination.
        attribute(:name, String)

        # @return [String] The destination identifier generated when you created the destination.
        attribute(:destination_id, String, from: "destinationId")

        # @return [DestinationResource] The resource that will receive notifications associated with this destination.
        attribute(:resource, DestinationResource)
      end
    end
  end
end
