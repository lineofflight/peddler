# frozen_string_literal: true

require "helper"

require "peddler/apis/orders_v0"

module Peddler
  module APIs
    class OrdersV0Test < Minitest::Test
      include FeatureHelpers

      def test_get_orders
        res = api.sandbox.get_orders(["ATVPDKIKX0DER"], created_after: "TEST_CASE_200")

        assert_predicate(res.status, :success?)
      end

      def test_get_order
        res = api.sandbox.get_order("TEST_CASE_200")

        assert_predicate(res.status, :success?)
      end

      def test_get_order_buyer_info
        res = api.sandbox.get_order_buyer_info("TEST_CASE_200")

        assert_predicate(res.status, :success?)
      end

      def test_get_order_address
        res = api.sandbox.get_order_address("TEST_CASE_200")

        assert_predicate(res.status, :success?)
      end

      def test_get_order_items
        res = api.sandbox.get_order_items("TEST_CASE_200")

        assert_predicate(res.status, :success?)
      end

      def test_get_order_items_buyer_info
        res = api.sandbox.get_order_items_buyer_info("TEST_CASE_200")

        assert_predicate(res.status, :success?)
      end

      def test_update_shipment_status
        payload = {
          marketplaceId: "ATVPDKIKX0DER",
          shipmentStatus: "ReadyForPickup",
        }
        res = api.sandbox.update_shipment_status("TEST_CASE_200", payload)

        assert_predicate(res.status, :success?)
      end

      def test_confirm_shipment
        payload = {
          "marketplaceId" => "ATVPDKIKX0DER",
          "packageDetail" => {
            "packageReferenceId" => "1",
            "carrierCode" => "FedEx",
            "carrierName" => "FedEx",
            "shippingMethod" => "FedEx Ground",
            "trackingNumber" => "112345678",
            "shipDate" => "2022-02-11T01:00:00.000Z",
            "shipFromSupplySourceId" => "057d3fcc-b750-419f-bbcd-4d340c60c430",
            "orderItems" => [
              {
                "orderItemId" => "79039765272157",
                "quantity" => 1,
                "transparencyCodes" => [
                  "09876543211234567890",
                ],
              },
            ],
          },
        }
        res = api.sandbox.confirm_shipment("902-1106328-1059050", payload)

        assert_predicate(res.status, :success?)
      end
    end
  end
end
