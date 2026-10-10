# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module FulfillmentInbound20240320
      # Contains information pertaining to the placement of the contents of an inbound plan and the related costs.
      PlacementOption = Structure.new do
        # Discount for the offered option.
        attribute(:discounts, [Incentive], null: false)

        # The fee for the offered option.
        attribute(:fees, [Incentive], null: false)

        # The identifier of a placement option. A placement option represents the shipment splits and destinations of
        # SKUs.
        attribute(:placement_option_id, String, null: false, from: "placementOptionId")

        # Shipment ids.
        attribute(:shipment_ids, [String], null: false, from: "shipmentIds")

        # The status of a placement option. Possible values: `OFFERED`, `ACCEPTED`, `EXPIRED`.
        attribute(:status, String, null: false)

        # The expiration date of the placement option. In [ISO
        # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) datetime format with pattern
        # `yyyy-MM-ddTHH:mm:ss.sssZ`.
        attribute?(:expiration, Time)
      end
    end
  end
end
