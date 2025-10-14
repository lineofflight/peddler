# frozen_string_literal: true

require "helper"

module Peddler
  module Notifications
    class AnyOfferChangedTest < Minitest::Test
      include FixtureHelpers

      def setup
        @payload = load_fixture("notifications/any_offer_changed.json")
      end

      def test_parses_notification
        # FIXME: Real Amazon notifications seem not to include Points, IsExpeditedShippingAvailable, etc. even though
        # generated types require them.
        skip("Required fields missing from data")
        notification = AnyOfferChanged.parse(@payload)

        assert_equal("ANY_OFFER_CHANGED", notification.notification_type)
      end
    end
  end
end
