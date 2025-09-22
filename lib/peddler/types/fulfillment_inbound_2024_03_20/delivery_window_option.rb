# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # Contains information pertaining to a delivery window option.
      DeliveryWindowOption = Structure.new do
        # @return [String] Identifies type of Delivery Window Availability. Values: `AVAILABLE`, `CONGESTED`
        attribute(:availability_type, String, from: "availabilityType")

        # @return [String] Identifier of a delivery window option. A delivery window option represent one option for
        # when a shipment is expected to be delivered.
        attribute(:delivery_window_option_id, String, from: "deliveryWindowOptionId")

        # @return [String] The time at which this delivery window option ends. In [ISO
        # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) datetime format with pattern
        # `yyyy-MM-ddTHH:mmZ`.
        attribute(:end_date, String, from: "endDate")

        # @return [String] The time at which this delivery window option starts. In [ISO
        # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) datetime format with pattern
        # `yyyy-MM-ddTHH:mmZ`.
        attribute(:start_date, String, from: "startDate")

        # @return [String] The time at which this window delivery option is no longer valid. In [ISO
        # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) datetime format with pattern
        # `yyyy-MM-ddTHH:mmZ`.
        attribute(:valid_until, String, from: "validUntil")
      end
    end
  end
end
