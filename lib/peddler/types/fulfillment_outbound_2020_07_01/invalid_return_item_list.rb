# frozen_string_literal: true

require "peddler/types/fulfillment_outbound_2020_07_01/invalid_return_item"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # An array of invalid return item information.
      class InvalidReturnItemList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| InvalidReturnItem.parse(item) })
          end
        end
      end
    end
  end
end
