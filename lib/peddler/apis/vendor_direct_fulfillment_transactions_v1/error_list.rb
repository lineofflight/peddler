# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class VendorDirectFulfillmentTransactionsV1
      # A list of error responses returned when a request is unsuccessful.
      class ErrorList < Array
        class << self
          def parse(array)
            new(array.map { |item| Error.parse(item) })
          end
        end
      end
    end
  end
end
