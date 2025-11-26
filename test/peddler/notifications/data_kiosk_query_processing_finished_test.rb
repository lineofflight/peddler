# frozen_string_literal: true

# Fixture extracted from Amazon's online documentation.
# https://developer-docs.amazon.com/sp-api/docs/data-kiosk-notification.md

require "helper"

module Peddler
  module Notifications
    class DataKioskQueryProcessingFinishedTest < Minitest::Test
      include FixtureHelpers

      def setup
        @payload = load_fixture("notifications/data_kiosk_query_processing_finished.json")
      end

      def test_parses_notification
        notification = DataKioskQueryProcessingFinished.parse(@payload)

        assert_equal("DATA_KIOSK_QUERY_PROCESSING_FINISHED", notification.notification_type)
      end
    end
  end
end
