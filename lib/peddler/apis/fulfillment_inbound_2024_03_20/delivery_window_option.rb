# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # Contains information pertaining to a delivery window option.
      DeliveryWindowOption = Structure.new do
        # @return [String] Identifies type of Delivery Window Availability. Values: `AVAILABLE`, `CONGESTED`
        attribute(:availability_type, String, from: "availabilityType")

        # @return [String] Identifier of a delivery window option. A delivery window option represent one option for
        #   when a shipment is expected to be delivered.
        attribute(:delivery_window_option_id, String, from: "deliveryWindowOptionId")

        # @return [Time] The time at which this delivery window option ends. In [ISO
        #   8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) datetime format with pattern
        #   `yyyy-MM-ddTHH:mmZ`.
        attribute(:end_date, Time, from: "endDate")

        # @return [Time] The time at which this delivery window option starts. In [ISO
        #   8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) datetime format with pattern
        #   `yyyy-MM-ddTHH:mmZ`.
        attribute(:start_date, Time, from: "startDate")

        # @return [Time] The time at which this window delivery option is no longer valid. In [ISO
        #   8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) datetime format with pattern
        #   `yyyy-MM-ddTHH:mmZ`.
        attribute(:valid_until, Time, from: "validUntil")
      end
    end
  end
end
