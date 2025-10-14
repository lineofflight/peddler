# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class FulfillmentInboundV0
      # A list of invalid SKU values and the reason they are invalid.
      class InvalidSKUList < Array
        class << self
          def parse(array)
            new(array.map { |item| InvalidSKU.parse(item) })
          end
        end
      end
    end
  end
end
