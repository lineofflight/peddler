# frozen_string_literal: true

# Fixture extracted from Amazon's online documentation.
# https://developer-docs.amazon.com/sp-api/docs/notification-type-values.md

require "helper"

module Peddler
  module Notifications
    class FBAOutboundShipmentStatusTest < Minitest::Test
      include FixtureHelpers

      def setup
        @payload = load_fixture("notifications/fba_outbound_shipment_status.json")
      end

      def test_parses_notification
        notification = FBAOutboundShipmentStatus.parse(@payload)

        assert_equal("FBA_OUTBOUND_SHIPMENT_STATUS", notification.notification_type)
      end
    end
  end
end
