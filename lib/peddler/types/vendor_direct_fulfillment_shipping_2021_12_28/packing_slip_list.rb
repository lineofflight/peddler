# frozen_string_literal: true

require "peddler/types/vendor_direct_fulfillment_shipping_2021_12_28/pagination"
require "peddler/types/vendor_direct_fulfillment_shipping_2021_12_28/packing_slip"

module Peddler
  module Types
    module VendorDirectFulfillmentShipping20211228
      # A list of packing slips.
      PackingSlipList = Structure.new do
        # @return [Pagination] The pagination elements required to retrieve the remaining data.
        attribute(:pagination, Pagination)

        # @return [Array<PackingSlip>] An array of packing slip objects.
        attribute(:packing_slips, [PackingSlip], from: "packingSlips")
      end
    end
  end
end
