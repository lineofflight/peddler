# frozen_string_literal: true

require "peddler/types/fulfillment_outbound_2020_07_01/invalid_return_item"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # An array of invalid return item information.
      class InvalidReturnItemList < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| InvalidReturnItem.parse(item) }) : new
          end
        end
      end
    end
  end
end
