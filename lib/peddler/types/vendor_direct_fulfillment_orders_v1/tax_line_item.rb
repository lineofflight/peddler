# frozen_string_literal: true

require "peddler/types/vendor_direct_fulfillment_orders_v1/tax_details"

module Peddler
  module Types
    module VendorDirectFulfillmentOrdersV1
      # A list of tax line items.
      class TaxLineItem < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| TaxDetails.parse(item) })
          end
        end
      end
    end
  end
end
