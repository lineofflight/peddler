# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/notifications_v1/error"
require "peddler/types/notifications_v1/destination"

module Peddler
  module Types
    module NotificationsV1
      # The response schema for the `getDestination` operation.
      GetDestinationResponse = Structure.new do
        # @return [Array<Error>] One or more unexpected errors occurred during the `getDestination` operation.
        attribute?(:errors, [Error])

        # @return [Destination] The payload for the `getDestination` operation.
        attribute?(:payload, Destination)
      end
    end
  end
end
