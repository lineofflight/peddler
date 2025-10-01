# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/vendor_shipments_v1/container_item"
require "peddler/types/vendor_shipments_v1/container_identification"
require "peddler/types/vendor_shipments_v1/dimensions"
require "peddler/types/vendor_shipments_v1/weight"

module Peddler
  module Types
    module VendorShipmentsV1
      # Details of the carton/package being shipped.
      Carton = Structure.new do
        # @return [String] Carton sequence number for the carton. The first carton will be 001, the second 002, and so
        # on. This number is used as a reference to refer to this carton from the pallet level.
        attribute(:carton_sequence_number, String, from: "cartonSequenceNumber")

        # @return [Array<ContainerItem>] A list of container item details.
        attribute(:items, [ContainerItem])

        # @return [Array<ContainerIdentification>] A list of carton identifiers.
        attribute?(:carton_identifiers, [ContainerIdentification], from: "cartonIdentifiers")

        # @return [Dimensions]
        attribute?(:dimensions, Dimensions)

        # @return [String] This is required to be provided for every carton in the small parcel shipments.
        attribute?(:tracking_number, String, from: "trackingNumber")

        # @return [Weight]
        attribute?(:weight, Weight)
      end
    end
  end
end
