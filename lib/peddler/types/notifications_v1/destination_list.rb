# frozen_string_literal: true

require "peddler/types/notifications_v1/destination"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module NotificationsV1
      # A list of destinations.
      class DestinationList < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| Destination.parse(item) }) : new
          end
        end
      end
    end
  end
end
