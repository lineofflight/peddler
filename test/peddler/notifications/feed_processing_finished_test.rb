# frozen_string_literal: true

require "helper"

module Peddler
  module Notifications
    class FeedProcessingFinishedTest < Minitest::Test
      include FixtureHelpers

      def setup
        @payload = load_fixture("notifications/feed_processing_finished.json")
      end

      def test_parses_notification
        notification = FeedProcessingFinished::Notification.parse(@payload)

        assert_equal("FEED_PROCESSING_FINISHED", notification.notification_type)
      end
    end
  end
end
