# frozen_string_literal: true

require "helper"

require "peddler/apis/notifications_v1"

module Peddler
  module APIs
    class NotificationsV1Test < Minitest::Test
      include FeatureHelpers

      def test_get_destinations
        res = api(grantless: true, typed: true).sandbox.get_destinations

        assert_predicate(res.status, :ok?)
      end

      def test_create_destination
        body = {
          resourceSpecification: {
            sqs: {
              arn: "arn:aws:sqs:us-east-1:123456789012:test-queue",
            },
          },
          name: "Test Destination",
        }
        res = api(grantless: true, typed: true).sandbox.create_destination(body)

        assert_predicate(res.status, :ok?)
      end

      def test_get_destination
        res = api(grantless: true, typed: true).sandbox.get_destination("TEST_DESTINATION_ID")

        assert_predicate(res.status, :ok?)
      end

      def test_delete_destination
        res = api(grantless: true, typed: true).sandbox.delete_destination("TEST_DESTINATION_ID")

        assert_predicate(res.status, :ok?)
      end

      def test_get_subscription
        res = api.sandbox.get_subscription("LISTINGS_ITEM_ISSUES_CHANGE")

        assert_predicate(res.status, :ok?)
      end

      def test_create_subscription
        body = {
          destinationId: "TEST_DESTINATION_ID",
          payloadVersion: "1.0",
        }
        res = api.sandbox.create_subscription(body, "ORDER_CHANGE")

        assert_predicate(res.status, :ok?)
      end
    end
  end
end
