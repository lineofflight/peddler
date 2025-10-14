# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module FBAOutboundShipmentStatus
      # Notification payload that wraps nested notification data
      Payload = Structure.new do
        # @return [FBAOutboundShipmentStatusNotification]
        attribute(:fba_outbound_shipment_status_notification, FBAOutboundShipmentStatusNotification, from: "FBAOutboundShipmentStatusNotification")
      end
    end
  end
end
