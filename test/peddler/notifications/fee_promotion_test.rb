# frozen_string_literal: true

# Fixture extracted from Amazon's online documentation.
# https://developer-docs.amazon.com/sp-api/docs/notification-type-values.md
#
# Note: Fixed property name from "PromotionInformations" to "PromotionInformation"
# to match the actual schema.

require "helper"

module Peddler
  module Notifications
    class FeePromotionTest < Minitest::Test
      include FixtureHelpers

      def setup
        @payload = load_fixture("notifications/fee_promotion.json")
      end

      def test_parses_notification
        notification = FeePromotion.parse(@payload)

        assert_equal("FEE_PROMOTION", notification.notification_type)
      end
    end
  end
end
