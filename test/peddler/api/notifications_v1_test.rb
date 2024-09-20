# frozen_string_literal: true

require "helper"

require "peddler/api/notifications_v1"

module Peddler
  class API
    class NotificationsV1Test < Minitest::Test
      def api(token = request_access_token)
        NotificationsV1.new(aws_region, token)
      end

      def test_get_destinations
        res = api(request_access_token(grantless: true)).sandbox.get_destinations

        assert_predicate(res.status, :ok?)
      end

      def test_get_subscription
        res = api.sandbox.get_subscription("LISTINGS_ITEM_ISSUES_CHANGE")

        assert_predicate(res.status, :ok?)
      end
    end
  end
end
