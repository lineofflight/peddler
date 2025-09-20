# frozen_string_literal: true

require "peddler/types/fulfillment_outbound_2020_07_01/delivery_window"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # An array of delivery windows.
      class DeliveryWindowList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| DeliveryWindow.parse(item) })
          end
        end
      end
    end
  end
end
