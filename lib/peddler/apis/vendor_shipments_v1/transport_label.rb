# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module VendorShipmentsV1
      # A list of one or more ShipmentLabels.
      TransportLabel = Structure.new do
        # Date on which label is created.
        attribute?(:label_create_date_time, Time, from: "labelCreateDateTime")

        # Indicates the label data,format and type associated .
        attribute?(:label_data, [LabelData], from: "labelData")

        # Indicates the shipment Information details like warehouse and business reference details like ARN, Selling
        # Party detail and Vendor Warehouse details
        attribute?(:shipment_information, ShipmentInformation, from: "shipmentInformation")
      end
    end
  end
end
