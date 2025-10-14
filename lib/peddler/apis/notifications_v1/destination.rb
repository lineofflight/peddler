# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class NotificationsV1
      # Information about the destination created when you call the `createDestination` operation.
      Destination = Structure.new do
        # @return [String] The destination identifier generated when you created the destination.
        attribute(:destination_id, String, from: "destinationId")

        # @return [String] The developer-defined name for this destination.
        attribute(:name, String)

        # @return [DestinationResource] The resource that will receive notifications associated with this destination.
        attribute(:resource, DestinationResource)
      end
    end
  end
end
