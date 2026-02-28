# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorDirectFulfillmentShippingV1
      # A container used for shipping and packing items.
      Container = Structure.new do
        # @return [String] The container identifier.
        attribute(:container_identifier, String, null: false, from: "containerIdentifier")

        # @return [String] The type of container.
        attribute(:container_type, String, null: false, from: "containerType")

        # @return [Array<PackedItem>] A list of packed items.
        attribute(:packed_items, [PackedItem], null: false, from: "packedItems")

        # @return [Weight]
        attribute(:weight, Weight, null: false)

        # @return [String] Carrier required for EU VOC vendors only.
        attribute?(:carrier, String)

        # @return [Integer] An integer that must be submitted for multi-box shipments only, where one item may come in
        #   separate packages.
        attribute?(:container_sequence_number, Integer, from: "containerSequenceNumber")

        # @return [Dimensions]
        attribute?(:dimensions, Dimensions)

        # @return [String] The date of the manifest.
        attribute?(:manifest_date, String, from: "manifestDate")

        # @return [String] The manifest identifier.
        attribute?(:manifest_id, String, from: "manifestId")

        # @return [String] SCAC code required for NA VOC vendors only.
        attribute?(:scac_code, String, from: "scacCode")

        # @return [String] The shipment method.
        attribute?(:ship_method, String, from: "shipMethod")

        # @return [String] The tracking number.
        attribute?(:tracking_number, String, from: "trackingNumber")
      end
    end
  end
end
