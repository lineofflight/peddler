# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorDirectFulfillmentShipping20211228
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
