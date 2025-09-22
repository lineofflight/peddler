# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/vendor_direct_fulfillment_shipping_v1/pagination"
require "peddler/types/vendor_direct_fulfillment_shipping_v1/packing_slip"

module Peddler
  module Types
    module VendorDirectFulfillmentShippingV1
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
