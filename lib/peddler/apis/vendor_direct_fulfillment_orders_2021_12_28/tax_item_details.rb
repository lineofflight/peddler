# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorDirectFulfillmentOrders20211228
      # Total tax details for the line item.
      TaxItemDetails = Structure.new do
        # @return [Array<TaxDetails>] Tax details.
        attribute?(:tax_line_item, [TaxDetails], from: "taxLineItem")
      end
    end
  end
end
