# frozen_string_literal: true

require "peddler/types/fulfillment_inbound_2024_03_20/box_input"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # Packing information for the inbound plan.
      PackageGroupingInput = Structure.new do
        # @return [Array<BoxInput>] Box level information being provided.
        attribute(:boxes, [BoxInput])

        # @return [String] The ID of the `packingGroup` that packages are grouped according to. The `PackingGroupId` can
        # only be provided before placement confirmation, and it must belong to the confirmed `PackingOption`. One of
        # `ShipmentId` or `PackingGroupId` must be provided with every request.
        attribute(:packing_group_id, String, from: "packingGroupId")

        # @return [String] The ID of the shipment that packages are grouped according to. The `ShipmentId` can only be
        # provided after placement confirmation, and the shipment must belong to the confirmed placement option. One of
        # `ShipmentId` or `PackingGroupId` must be provided with every request.
        attribute(:shipment_id, String, from: "shipmentId")
      end
    end
  end
end
