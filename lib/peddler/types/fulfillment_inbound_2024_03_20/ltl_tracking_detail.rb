# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # Contains information related to Less-Than-Truckload (LTL) shipment tracking.
      LtlTrackingDetail = Structure.new do
        # @return [String] The number of the carrier shipment acknowledgement document.
        attribute(:bill_of_lading_number, String, from: "billOfLadingNumber")

        # @return [Array<String>] The number associated with the freight bill.
        attribute(:freight_bill_number, [String], from: "freightBillNumber")
      end
    end
  end
end
