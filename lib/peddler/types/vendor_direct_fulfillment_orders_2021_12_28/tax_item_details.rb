# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/vendor_direct_fulfillment_orders_2021_12_28/tax_details"

module Peddler
  module Types
    module VendorDirectFulfillmentOrders20211228
      # Total tax details for the line item.
      TaxItemDetails = Structure.new do
        # @return [Array<TaxDetails>] Tax details.
        attribute?(:tax_line_item, [TaxDetails], from: "taxLineItem")
      end
    end
  end
end
