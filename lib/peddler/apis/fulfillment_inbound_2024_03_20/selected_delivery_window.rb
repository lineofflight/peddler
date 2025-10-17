# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # Selected delivery window attributes.
      SelectedDeliveryWindow = Structure.new do
        # @return [String] Identifies type of Delivery Window Availability. Values: `AVAILABLE`, `CONGESTED`
        attribute(:availability_type, String, from: "availabilityType")

        # @return [String] Identifier of a delivery window option. A delivery window option represent one option for
        #   when a shipment is expected to be delivered.
        attribute(:delivery_window_option_id, String, from: "deliveryWindowOptionId")

        # @return [Time] The end timestamp of the window.
        attribute(:end_date, Time, from: "endDate")

        # @return [Time] The start timestamp of the window.
        attribute(:start_date, Time, from: "startDate")

        # @return [Time] The timestamp at which this Window can no longer be edited.
        attribute?(:editable_until, Time, from: "editableUntil")
      end
    end
  end
end
