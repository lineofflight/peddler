# frozen_string_literal: true

require "peddler/types/shipping_v1/event"

module Peddler
  module Types
    module ShippingV1
      # A list of events of a shipment.
      class EventList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| Event.parse(item) })
          end
        end
      end
    end
  end
end
