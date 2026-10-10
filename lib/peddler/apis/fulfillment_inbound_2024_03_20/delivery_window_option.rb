# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module FulfillmentInbound20240320
      # Contains information pertaining to a delivery window option.
      DeliveryWindowOption = Structure.new do
        # The type of delivery window availability. Values: `AVAILABLE`, `BLOCKED`, `CONGESTED`, `DISCOUNTED`
        attribute(:availability_type, String, null: false, from: "availabilityType")

        # Identifier of a delivery window option. A delivery window option represent one option for when a shipment is
        # expected to be delivered.
        attribute(:delivery_window_option_id, String, null: false, from: "deliveryWindowOptionId")

        # The time at which this delivery window option ends. In [ISO
        # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) datetime format with pattern
        # `yyyy-MM-ddTHH:mmZ`.
        attribute(:end_date, Time, null: false, from: "endDate")

        # The time at which this delivery window option starts. In [ISO
        # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) datetime format with pattern
        # `yyyy-MM-ddTHH:mmZ`.
        attribute(:start_date, Time, null: false, from: "startDate")

        # The time at which this window delivery option is no longer valid. In [ISO
        # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) datetime format with pattern
        # `yyyy-MM-ddTHH:mmZ`.
        attribute(:valid_until, Time, null: false, from: "validUntil")

        # Discounts for the offered option.
        attribute?(:discounts, [Incentive])
      end
    end
  end
end
