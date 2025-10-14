# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class FulfillmentInboundV0
      # A list of invalid ASIN values and the reasons they are invalid.
      class InvalidASINList < Array
        class << self
          def parse(array)
            new(array.map { |item| InvalidASIN.parse(item) })
          end
        end
      end
    end
  end
end
