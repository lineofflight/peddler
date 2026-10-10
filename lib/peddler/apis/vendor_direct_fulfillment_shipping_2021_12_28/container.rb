# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module VendorDirectFulfillmentShipping20211228
      # A container used for shipping and packing items.
      Container = Structure.new do
        # The container identifier.
        attribute(:container_identifier, String, null: false, from: "containerIdentifier")

        # The type of container.
        attribute(:container_type, String, null: false, from: "containerType")

        # A list of packed items.
        attribute(:packed_items, [PackedItem], null: false, from: "packedItems")

        attribute(:weight, Weight, null: false)

        # Carrier required for EU VOC vendors only.
        attribute?(:carrier, String)

        # An integer that must be submitted for multi-box shipments only, where one item may come in separate packages.
        attribute?(:container_sequence_number, Integer, from: "containerSequenceNumber")

        attribute?(:dimensions, Dimensions)

        # The date of the manifest.
        attribute?(:manifest_date, String, from: "manifestDate")

        # The manifest identifier.
        attribute?(:manifest_id, String, from: "manifestId")

        # SCAC code required for NA VOC vendors only.
        attribute?(:scac_code, String, from: "scacCode")

        # The shipment method. This property is required when calling the `submitShipmentConfirmations` operation, and
        # optional otherwise.
        attribute?(:ship_method, String, from: "shipMethod")

        # The tracking number.
        attribute?(:tracking_number, String, from: "trackingNumber")
      end
    end
  end
end
