# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module VendorShipmentsV1
      # Label details as part of the transport label response
      LabelData = Structure.new do
        # Unique identification of the carrier.
        attribute?(:carrier_code, String, from: "carrierCode")

        # The base-64 encoded string that represents the shipment label.
        attribute?(:label, String)

        # The format of the label.
        attribute?(:label_format, String, from: "labelFormat")

        # A sequential number assigned to each label within a shipment.
        attribute?(:label_sequence_number, Integer, from: "labelSequenceNumber")

        # Tracking Id for the transportation.
        attribute?(:tracking_id, String, from: "trackingId")
      end
    end
  end
end
