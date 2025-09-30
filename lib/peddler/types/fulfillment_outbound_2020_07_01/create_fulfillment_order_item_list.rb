# frozen_string_literal: true

require "peddler/types/fulfillment_outbound_2020_07_01/create_fulfillment_order_item"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # An array of item information for creating a fulfillment order.
      class CreateFulfillmentOrderItemList < Array
        class << self
          def parse(array)
            new(array.map { |item| CreateFulfillmentOrderItem.parse(item) })
          end
        end
      end
    end
  end
end
