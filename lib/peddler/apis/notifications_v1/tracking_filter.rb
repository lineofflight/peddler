# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class NotificationsV1
      # An event filter you can use to customize your subscription to receive shipment tracking milestone notifications
      # for a specific tracking identifier.
      TrackingFilter = Structure.new do
        # @return [TrackingIdentifier]
        attribute?(:tracking_identifier, TrackingIdentifier, from: "trackingIdentifier")
      end
    end
  end
end
