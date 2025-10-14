# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class FulfillmentOutbound20200701
      # An array of items that Amazon accepted for return. Returns empty if no items were accepted for return.
      class ReturnItemList < Array
        class << self
          def parse(array)
            new(array.map { |item| ReturnItem.parse(item) })
          end
        end
      end
    end
  end
end
