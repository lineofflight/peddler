# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module FulfillmentInbound20240320
      # Inbound plan containing details of the inbound workflow.
      InboundPlan = Structure.new do
        # The time at which the inbound plan was created. In [ISO
        # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) datetime with pattern `yyyy-MM-ddTHH:mm:ssZ`.
        attribute(:created_at, Time, null: false, from: "createdAt")

        # Identifier of an inbound plan.
        attribute(:inbound_plan_id, String, null: false, from: "inboundPlanId")

        # The time at which the inbound plan was last updated. In [ISO
        # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) datetime format with pattern
        # `yyyy-MM-ddTHH:mm:ssZ`.
        attribute(:last_updated_at, Time, null: false, from: "lastUpdatedAt")

        # A list of marketplace IDs.
        attribute(:marketplace_ids, [String], null: false, from: "marketplaceIds")

        # Human-readable name of the inbound plan.
        attribute(:name, String, null: false)

        attribute(:source_address, Address, null: false, from: "sourceAddress")

        # Current status of the inbound plan. Possible values: `ACTIVE`, `VOIDED`, `SHIPPED`, `ERRORED`.
        attribute(:status, String, null: false)

        # Packing options for the inbound plan. This property will be populated when it has been generated via the
        # corresponding operation. If there is a chosen placement option, only packing options for that placement option
        # will be returned. If there are confirmed shipments, only packing options for those shipments will be returned.
        # Query the packing option for more details.
        attribute?(:packing_options, [PackingOptionSummary], from: "packingOptions")

        # Placement options for the inbound plan. This property will be populated when it has been generated via the
        # corresponding operation. If there is a chosen placement option, that will be the only returned option. Query
        # the placement option for more details.
        attribute?(:placement_options, [PlacementOptionSummary], from: "placementOptions")

        # A list of shipment IDs for the inbound plan. This property is populated when it has been generated with the
        # `confirmPlacementOptions` operation. Only shipments from the chosen placement option are returned. Query the
        # shipment for more details.
        attribute?(:shipments, [ShipmentSummary])
      end
    end
  end
end
