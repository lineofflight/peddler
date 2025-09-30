# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/vendor_shipments_v1/shipment_information"
require "peddler/types/vendor_shipments_v1/label_data"

module Peddler
  module Types
    module VendorShipmentsV1
      # A list of one or more ShipmentLabels.
      TransportLabel = Structure.new do
        # @return [String] Date on which label is created.
        attribute?(:label_create_date_time, String, from: "labelCreateDateTime")

        # @return [ShipmentInformation] Indicates the shipment Information details like warehouse and business reference
        # details like ARN, Selling Party detail and Vendor Warehouse details
        attribute?(:shipment_information, ShipmentInformation, from: "shipmentInformation")

        # @return [Array<LabelData>] Indicates the label data,format and type associated .
        attribute?(:label_data, [LabelData], from: "labelData")
      end
    end
  end
end
