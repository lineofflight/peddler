# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class FulfillmentOutbound20200701
      # An array of tracking event information.
      class TrackingEventList < Array
        class << self
          def parse(array)
            new(array.map { |item| TrackingEvent.parse(item) })
          end
        end
      end
    end
  end
end
