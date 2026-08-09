# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module ShipmentTrackingMilestoneChanged
      # Notification sent when a shipment tracking milestone changes.
      Notification = Structure.new do
        # @return [Payload]
        attribute(:payload, Payload, null: false)
      end
    end
  end
end
