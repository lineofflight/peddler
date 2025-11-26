# frozen_string_literal: true

# Fixture extracted from Amazon's online documentation.
# https://developer-docs.amazon.com/sp-api/docs/notification-type-values.md

require "helper"

module Peddler
  module Notifications
    class ReportProcessingFinishedTest < Minitest::Test
      include FixtureHelpers

      def setup
        @payload = load_fixture("notifications/report_processing_finished.json")
      end

      def test_parses_notification
        notification = ReportProcessingFinished.parse(@payload)

        assert_equal("REPORT_PROCESSING_FINISHED", notification.notification_type)
      end
    end
  end
end
