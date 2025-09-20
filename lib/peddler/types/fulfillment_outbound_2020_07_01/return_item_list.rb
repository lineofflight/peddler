# frozen_string_literal: true

require "peddler/types/fulfillment_outbound_2020_07_01/return_item"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # An array of items that Amazon accepted for return. Returns empty if no items were accepted for return.
      class ReturnItemList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| ReturnItem.parse(item) })
          end
        end
      end
    end
  end
end
