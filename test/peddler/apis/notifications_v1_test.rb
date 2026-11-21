# frozen_string_literal: true

require "helper"

module Peddler
  module APIs
    class NotificationsV1Test < Minitest::Test
      include FeatureHelpers

      def test_get_destinations
        res = api.get_destinations

        assert_equal(200, res.status)
        assert_success(res)
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
        res = api.create_destination(body)

        assert_equal(200, res.status)
        assert_success(res)
      end

      def test_get_destination
        res = api.get_destination("TEST_DESTINATION_ID")

        assert_equal(200, res.status)
        assert_success(res)
      end

      def test_delete_destination
        res = api.delete_destination("TEST_DESTINATION_ID")

        assert_equal(200, res.status)
        assert_success(res)
      end

      def test_get_subscription
        res = api.get_subscription("LISTINGS_ITEM_ISSUES_CHANGE")

        assert_equal(200, res.status)
        assert_success(res)
      end

      def test_create_subscription
        body = {
          destinationId: "TEST_DESTINATION_ID",
          payloadVersion: "1.0",
        }
        res = api.create_subscription(body, "ORDER_CHANGE")

        assert_equal(200, res.status)
        assert_success(res)
      end
    end
  end
end
