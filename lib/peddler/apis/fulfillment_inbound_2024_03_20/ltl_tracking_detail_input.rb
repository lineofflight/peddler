# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentInbound20240320
      # Contains input information to update Less-Than-Truckload (LTL) tracking information.
      LtlTrackingDetailInput = Structure.new do
        # Number associated with the freight bill.
        attribute(:freight_bill_number, [String], null: false, from: "freightBillNumber")

        # The number of the carrier shipment acknowledgement document.
        attribute?(:bill_of_lading_number, String, from: "billOfLadingNumber")
      end
    end
  end
end
