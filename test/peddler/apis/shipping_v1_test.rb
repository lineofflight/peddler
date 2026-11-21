# frozen_string_literal: true

require "helper"

module Peddler
  module APIs
    class ShippingV1Test < Minitest::Test
      include FeatureHelpers

      def test_create_shipment
        res = api.create_shipment({ "clientReferenceId" => "TEST_CASE_200" })

        assert_success(res)
      end

      def test_get_shipment
        res = api.get_shipment("TEST_CASE_200")

        assert_success(res, typed: false)
      end

      def test_cancel_shipment
        res = api.cancel_shipment("TEST_CASE_200")

        assert_success(res)
      end

      def test_purchase_labels
        res = api.purchase_labels("TEST_CASE_200", {})

        assert_success(res)
      end

      def test_retrieve_shipping_label
        # v5 recorded this with an empty tracking ID
        res = api.retrieve_shipping_label("TEST_CASE_200", "", {})

        assert_success(res)
      end

      def test_purchase_shipment
        res = api.purchase_shipment({ "clientReferenceId" => "TEST_CASE_2000" })

        assert_success(res)
      end

      def test_get_tracking_information
        res = api.get_tracking_information("TEST_CASE_200")

        assert_success(res)
      end
    end
  end
end
