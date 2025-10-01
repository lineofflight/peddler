# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/fulfillment_outbound_2020_07_01/delivery_window"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # Delivery information for a scheduled delivery. This is only available in the JP marketplace.
      ScheduledDeliveryInfo = Structure.new do
        # @return [String] The time zone of the destination address for the fulfillment order preview. Must be an IANA
        # time zone name. Example: Asia/Tokyo.
        attribute(:delivery_time_zone, String, from: "deliveryTimeZone")

        # @return [Array<DeliveryWindow>] An array of time ranges that are available for scheduled delivery.
        attribute(:delivery_windows, [DeliveryWindow], from: "deliveryWindows")
      end
    end
  end
end
