# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorShipmentsV1
      # Label details as part of the transport label response
      LabelData = Structure.new do
        # @return [String] Unique identification of the carrier.
        attribute?(:carrier_code, String, from: "carrierCode")

        # @return [String] The base-64 encoded string that represents the shipment label.
        attribute?(:label, String)

        # @return [String] The format of the label.
        attribute?(:label_format, String, from: "labelFormat")

        # @return [Integer] A sequential number assigned to each label within a shipment.
        attribute?(:label_sequence_number, Integer, from: "labelSequenceNumber")

        # @return [String] Tracking Id for the transportation.
        attribute?(:tracking_id, String, from: "trackingId")
      end
    end
  end
end
