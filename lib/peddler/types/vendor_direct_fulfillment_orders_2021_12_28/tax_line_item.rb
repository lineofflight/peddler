# frozen_string_literal: true

require "peddler/types/vendor_direct_fulfillment_orders_2021_12_28/tax_details"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module VendorDirectFulfillmentOrders20211228
      # A list of tax line items.
      class TaxLineItem < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| TaxDetails.parse(item) }) : new
          end
        end
      end
    end
  end
end
