# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # Contains information about a box that is used in the inbound plan. The box is a container that holds multiple
      # items.
      Box = Structure.new do
        # @return [String] Primary key to uniquely identify a Package (Box or Pallet).
        attribute(:package_id, String, from: "packageId")

        # @return [String] The ID provided by Amazon that identifies a given box. This ID is comprised of the external
        #   shipment ID (which is generated after transportation has been confirmed) and the index of the box.
        attribute?(:box_id, String, from: "boxId")

        # @return [String]
        attribute?(:content_information_source, String, from: "contentInformationSource")

        # @return [Region]
        attribute?(:destination_region, Region, from: "destinationRegion")

        # @return [Dimensions]
        attribute?(:dimensions, Dimensions)

        # @return [String] The external identifier for this container / box.
        attribute?(:external_container_identifier, String, from: "externalContainerIdentifier")

        # @return [String] Type of the external identifier used. Can be: `AMAZON`, `SSCC`.
        attribute?(:external_container_identifier_type, String, from: "externalContainerIdentifierType")

        # @return [Array<Item>] Items contained within the box.
        attribute?(:items, [Item])

        # @return [Integer] The number of containers where all other properties like weight or dimensions are identical.
        attribute?(:quantity, Integer)

        # @return [String] Template name of the box.
        attribute?(:template_name, String, from: "templateName")

        # @return [Weight]
        attribute?(:weight, Weight)
      end
    end
  end
end
