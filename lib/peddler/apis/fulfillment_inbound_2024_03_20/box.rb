# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentInbound20240320
      # Contains information about a box that is used in the inbound plan. The box is a container that holds multiple
      # items.
      Box = Structure.new do
        # Primary key to uniquely identify a Package (Box or Pallet).
        attribute(:package_id, String, null: false, from: "packageId")

        # The ID provided by Amazon that identifies a given box. This ID is comprised of the external shipment ID (which
        # is generated after transportation has been confirmed) and the index of the box.
        attribute?(:box_id, String, from: "boxId")

        # Known values: `BOX_CONTENT_PROVIDED`, `MANUAL_PROCESS`, `BARCODE_2D`.
        attribute?(:content_information_source, String, from: "contentInformationSource")

        attribute?(:destination_region, Region, from: "destinationRegion")

        attribute?(:dimensions, Dimensions)

        # The external identifier for this container / box.
        attribute?(:external_container_identifier, String, from: "externalContainerIdentifier")

        # Type of the external identifier used. Can be: `AMAZON`, `SSCC`.
        attribute?(:external_container_identifier_type, String, from: "externalContainerIdentifierType")

        # Items contained within the box.
        attribute?(:items, [Item])

        # The number of containers where all other properties like weight or dimensions are identical.
        attribute?(:quantity, Integer)

        # Template name of the box.
        attribute?(:template_name, String, from: "templateName")

        attribute?(:weight, Weight)
      end
    end
  end
end
