# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module VendorDirectFulfillmentShippingV1
      # A list of packing slips.
      PackingSlipList = Structure.new do
        # An array of packing slip objects.
        attribute?(:packing_slips, [PackingSlip], from: "packingSlips")

        # The pagination elements required to retrieve the remaining data.
        attribute?(:pagination, Pagination)
      end
    end
  end
end
