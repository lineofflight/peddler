# frozen_string_literal: true

require "helper"

module Peddler
  module APIs
    class ShippingV1Test < Minitest::Test
      include FeatureHelpers

      def test_create_shipment
        res = api.create_shipment(body: { "clientReferenceId" => "TEST_CASE_200" })

        assert_success(res)
      end

      def test_get_shipment
        res = api.get_shipment(shipment_id: "TEST_CASE_200")

        assert_success(res, typed: false)
      end

      def test_cancel_shipment
        res = api.cancel_shipment(shipment_id: "TEST_CASE_200")

        assert_success(res)
      end

      def test_purchase_labels
        res = api.purchase_labels(shipment_id: "TEST_CASE_200", body: {})

        assert_success(res)
      end

      def test_retrieve_shipping_label
        # v5 recorded this with an empty tracking ID. The generated method rejects one before any request, so the
        # recording is replayed through a raw request under the same operation.
        assert_raises(ArgumentError) { api.retrieve_shipping_label(shipment_id: "TEST_CASE_200", tracking_id: "", body: {}) }
        res = client.request("POST", "/shipping/v1/shipments/TEST_CASE_200/containers//label", body: {},
          operation: "shipping_v1.retrieve_shipping_label")

        assert_success(res)
      end

      def test_purchase_shipment
        res = api.purchase_shipment(body: { "clientReferenceId" => "TEST_CASE_2000" })

        assert_success(res)
      end

      def test_get_tracking_information
        res = api.get_tracking_information(tracking_id: "TEST_CASE_200")

        assert_success(res)
      end
    end
  end
end
