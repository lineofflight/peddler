# frozen_string_literal: true

require "peddler/types/fulfillment_inbound_2024_03_20/incentive"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # Contains information pertaining to the placement of the contents of an inbound plan and the related costs.
      PlacementOption = Structure.new do
        # @return [Array<Incentive>] Discount for the offered option.
        attribute(:discounts, [Incentive])

        # @return [String] The expiration date of the placement option. In [ISO
        # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) datetime format with pattern
        # `yyyy-MM-ddTHH:mm:ss.sssZ`.
        attribute(:expiration, String)

        # @return [Array<Incentive>] The fee for the offered option.
        attribute(:fees, [Incentive])

        # @return [String] The identifier of a placement option. A placement option represents the shipment splits and
        # destinations of SKUs.
        attribute(:placement_option_id, String, from: "placementOptionId")

        # @return [Array<String>] Shipment ids.
        attribute(:shipment_ids, [String], from: "shipmentIds")

        # @return [String] The status of a placement option. Possible values: `OFFERED`, `ACCEPTED`, `EXPIRED`.
        attribute(:status, String)
      end
    end
  end
end
