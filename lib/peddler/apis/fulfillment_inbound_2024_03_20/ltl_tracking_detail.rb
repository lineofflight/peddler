# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # Contains information related to Less-Than-Truckload (LTL) shipment tracking.
      LtlTrackingDetail = Structure.new do
        # @return [String] The number of the carrier shipment acknowledgement document.
        attribute?(:bill_of_lading_number, String, from: "billOfLadingNumber")

        # @return [Array<String>] The number associated with the freight bill.
        attribute?(:freight_bill_number, [String], from: "freightBillNumber")
      end
    end
  end
end
