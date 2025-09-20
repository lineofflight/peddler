# frozen_string_literal: true

require "peddler/types/fulfillment_outbound_2020_07_01/create_return_item"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # An array of items to be returned.
      class CreateReturnItemList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| CreateReturnItem.parse(item) })
          end
        end
      end
    end
  end
end
