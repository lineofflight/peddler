# frozen_string_literal: true

require "helper"

module Peddler
  module APIs
    class ShippingV1Test < Minitest::Test
      include FeatureHelpers

      def test_create_shipment
        res = api.sandbox.create_shipment({ "clientReferenceId" => "TEST_CASE_200" })

        assert_predicate(res.status, :success?)
      end

      def test_get_shipment
        res = api.sandbox.get_shipment("TEST_CASE_200")

        assert_predicate(res.status, :success?)
      end

      def test_cancel_shipment
        res = api.sandbox.cancel_shipment("TEST_CASE_200")

        assert_predicate(res.status, :success?)
      end

      def test_purchase_labels
        res = api.sandbox.purchase_labels("TEST_CASE_200", nil)

        assert_predicate(res.status, :success?)
      end

      def test_retrieve_shipping_label
        res = api.sandbox.retrieve_shipping_label("TEST_CASE_200", nil, nil)

        assert_predicate(res.status, :success?)
      end

      def test_purchase_shipment
        res = api.sandbox.purchase_shipment({ "clientReferenceId" => "TEST_CASE_2000" })

        assert_predicate(res.status, :success?)
      end

      def test_get_tracking_information
        res = api.sandbox.get_tracking_information("TEST_CASE_200")

        assert_predicate(res.status, :success?)
      end
    end
  end
end
