# frozen_string_literal: true

require "peddler/types/fulfillment_outbound_2020_07_01/tracking_event"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # An array of tracking event information.
      class TrackingEventList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| TrackingEvent.parse(item) })
          end
        end
      end
    end
  end
end
