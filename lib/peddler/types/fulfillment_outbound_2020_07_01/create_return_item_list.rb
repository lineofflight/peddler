# frozen_string_literal: true

require "peddler/types/fulfillment_outbound_2020_07_01/create_return_item"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # An array of items to be returned.
      class CreateReturnItemList < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| CreateReturnItem.parse(item) }) : new
          end
        end
      end
    end
  end
end
