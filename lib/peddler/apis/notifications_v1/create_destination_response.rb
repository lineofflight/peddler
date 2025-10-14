# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class NotificationsV1
      # The response schema for the createDestination operation.
      CreateDestinationResponse = Structure.new do
        # @return [Array<Error>] One or more unexpected errors occurred during the `createDestination` operation.
        attribute?(:errors, [Error])

        # @return [Destination] The payload for the `createDestination` operation.
        attribute?(:payload, Destination)
      end
    end
  end
end
