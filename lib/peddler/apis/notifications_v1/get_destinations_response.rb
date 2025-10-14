# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class NotificationsV1
      # The response schema for the `getDestinations` operation.
      GetDestinationsResponse = Structure.new do
        # @return [Array<Error>] One or more unexpected errors occurred during the `getDestinations` operation.
        attribute?(:errors, [Error])

        # @return [Array<Destination>] The payload for the `getDestinations` operation.
        attribute?(:payload, [Destination])
      end
    end
  end
end
