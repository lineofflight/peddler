# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class FulfillmentOutbound20200701
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
