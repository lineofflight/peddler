# frozen_string_literal: true

require "peddler/types/notifications_v1/destination"
require "peddler/types/notifications_v1/error"

module Peddler
  module Types
    module NotificationsV1
      # The response schema for the createDestination operation.
      CreateDestinationResponse = Structure.new do
        # @return [Destination] The payload for the `createDestination` operation.
        attribute(:payload, Destination)

        # @return [Array<Error>] One or more unexpected errors occurred during the `createDestination` operation.
        attribute(:errors, [Error])
      end
    end
  end
end
