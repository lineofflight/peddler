# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class VendorShipmentsV1
      # A list of one or more ShipmentLabels.
      TransportLabel = Structure.new do
        # @return [Time] Date on which label is created.
        attribute?(:label_create_date_time, Time, from: "labelCreateDateTime")

        # @return [Array<LabelData>] Indicates the label data,format and type associated .
        attribute?(:label_data, [LabelData], from: "labelData")

        # @return [ShipmentInformation] Indicates the shipment Information details like warehouse and business reference
        #   details like ARN, Selling Party detail and Vendor Warehouse details
        attribute?(:shipment_information, ShipmentInformation, from: "shipmentInformation")
      end
    end
  end
end
