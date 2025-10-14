# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class NotificationsV1
      # The response schema for the `deleteDestination` operation.
      DeleteDestinationResponse = Structure.new do
        # @return [Array<Error>] One or more unexpected errors occurred during the `deleteDestination` operation.
        attribute?(:errors, [Error])
      end
    end
  end
end
