# frozen_string_literal: true

require "helper"

require "peddler/apis/notifications_v1"

module Peddler
  module APIs
    class NotificationsV1Test < Minitest::Test
      include FeatureHelpers

      def test_get_destinations
        res = api(grantless: true).sandbox.get_destinations

        assert_predicate(res.status, :ok?)
      end

      def test_get_subscription
        res = api.sandbox.get_subscription("LISTINGS_ITEM_ISSUES_CHANGE")

        assert_predicate(res.status, :ok?)
      end
    end
  end
end
