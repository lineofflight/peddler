# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class VendorDirectFulfillmentOrders20211228
      # A list of tax line items.
      class TaxLineItem < Array
        class << self
          def parse(array)
            new(array.map { |item| TaxDetails.parse(item) })
          end
        end
      end
    end
  end
end
