# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentInbound20240320
      # Contains information related to Less-Than-Truckload (LTL) shipment tracking.
      LtlTrackingDetail = Structure.new do
        # The number of the carrier shipment acknowledgement document.
        attribute?(:bill_of_lading_number, String, from: "billOfLadingNumber")

        # The number associated with the freight bill.
        attribute?(:freight_bill_number, [String], from: "freightBillNumber")
      end
    end
  end
end
