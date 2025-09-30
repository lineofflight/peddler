# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/notifications_v1/destination"
require "peddler/types/notifications_v1/error"

module Peddler
  module Types
    module NotificationsV1
      # The response schema for the `getDestination` operation.
      GetDestinationResponse = Structure.new do
        # @return [Destination] The payload for the `getDestination` operation.
        attribute?(:payload, Destination)

        # @return [Array<Error>] One or more unexpected errors occurred during the `getDestination` operation.
        attribute?(:errors, [Error])
      end
    end
  end
end
