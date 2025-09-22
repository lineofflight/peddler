# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # Selected delivery window attributes.
      SelectedDeliveryWindow = Structure.new do
        # @return [String] Identifies type of Delivery Window Availability. Values: `AVAILABLE`, `CONGESTED`
        attribute(:availability_type, String, from: "availabilityType")

        # @return [String] Identifier of a delivery window option. A delivery window option represent one option for
        # when a shipment is expected to be delivered.
        attribute(:delivery_window_option_id, String, from: "deliveryWindowOptionId")

        # @return [String] The timestamp at which this Window can no longer be edited.
        attribute(:editable_until, String, from: "editableUntil")

        # @return [String] The end timestamp of the window.
        attribute(:end_date, String, from: "endDate")

        # @return [String] The start timestamp of the window.
        attribute(:start_date, String, from: "startDate")
      end
    end
  end
end
