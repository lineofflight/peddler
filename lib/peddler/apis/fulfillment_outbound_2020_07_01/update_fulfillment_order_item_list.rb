# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class FulfillmentOutbound20200701
      # An array of fulfillment order item information for updating a fulfillment order.
      class UpdateFulfillmentOrderItemList < Array
        class << self
          def parse(array)
            new(array.map { |item| UpdateFulfillmentOrderItem.parse(item) })
          end
        end
      end
    end
  end
end
