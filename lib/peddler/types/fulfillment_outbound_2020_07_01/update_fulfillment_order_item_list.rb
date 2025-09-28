# frozen_string_literal: true

require "peddler/types/fulfillment_outbound_2020_07_01/update_fulfillment_order_item"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # An array of fulfillment order item information for updating a fulfillment order.
      class UpdateFulfillmentOrderItemList < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| UpdateFulfillmentOrderItem.parse(item) }) : new
          end
        end
      end
    end
  end
end
