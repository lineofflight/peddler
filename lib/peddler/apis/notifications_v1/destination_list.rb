# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class NotificationsV1
      # A list of destinations.
      class DestinationList < Array
        class << self
          def parse(array)
            new(array.map { |item| Destination.parse(item) })
          end
        end
      end
    end
  end
end
