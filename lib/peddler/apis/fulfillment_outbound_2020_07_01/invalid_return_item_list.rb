# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class FulfillmentOutbound20200701
      # An array of invalid return item information.
      class InvalidReturnItemList < Array
        class << self
          def parse(array)
            new(array.map { |item| InvalidReturnItem.parse(item) })
          end
        end
      end
    end
  end
end
