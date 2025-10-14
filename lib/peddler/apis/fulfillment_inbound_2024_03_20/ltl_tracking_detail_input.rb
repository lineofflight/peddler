# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # Contains input information to update Less-Than-Truckload (LTL) tracking information.
      LtlTrackingDetailInput = Structure.new do
        # @return [Array<String>] Number associated with the freight bill.
        attribute(:freight_bill_number, [String], from: "freightBillNumber")

        # @return [String] The number of the carrier shipment acknowledgement document.
        attribute?(:bill_of_lading_number, String, from: "billOfLadingNumber")
      end
    end
  end
end
