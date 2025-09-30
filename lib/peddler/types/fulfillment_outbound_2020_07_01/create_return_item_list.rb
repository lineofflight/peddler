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
            new(array.map { |item| CreateReturnItem.parse(item) })
          end
        end
      end
    end
  end
end
