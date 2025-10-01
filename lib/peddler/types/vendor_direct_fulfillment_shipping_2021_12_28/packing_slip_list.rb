# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/vendor_direct_fulfillment_shipping_2021_12_28/packing_slip"
require "peddler/types/vendor_direct_fulfillment_shipping_2021_12_28/pagination"

module Peddler
  module Types
    module VendorDirectFulfillmentShipping20211228
      # A list of packing slips.
      PackingSlipList = Structure.new do
        # @return [Array<PackingSlip>] An array of packing slip objects.
        attribute?(:packing_slips, [PackingSlip], from: "packingSlips")

        # @return [Pagination] The pagination elements required to retrieve the remaining data.
        attribute?(:pagination, Pagination)
      end
    end
  end
end
