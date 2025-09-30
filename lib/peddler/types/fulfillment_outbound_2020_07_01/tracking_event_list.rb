# frozen_string_literal: true

require "peddler/types/fulfillment_outbound_2020_07_01/tracking_event"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module FulfillmentOutbound20200701
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
