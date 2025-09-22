# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/notifications_v1/error"

module Peddler
  module Types
    module NotificationsV1
      # The response schema for the `deleteDestination` operation.
      DeleteDestinationResponse = Structure.new do
        # @return [Array<Error>] One or more unexpected errors occurred during the `deleteDestination` operation.
        attribute(:errors, [Error])
      end
    end
  end
end
