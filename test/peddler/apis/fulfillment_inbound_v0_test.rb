# frozen_string_literal: true

require "helper"
require "peddler/apis/fulfillment_inbound_v0"

module Peddler
  module APIs
    class FulfillmentInboundV0Test < Minitest::Test
      include FeatureHelpers

      def test_get_prep_instructions
        res = api.sandbox.get_prep_instructions("US", asin_list: ["ASIN1"])

        assert_predicate(res.status, :success?)
      end

      def test_get_labels
        res = api.sandbox.get_labels("348975493", "PackageLabel_Letter_2", "BARCODE_2D")

        assert_predicate(res.status, :success?)
      end

      def test_get_bill_of_lading
        res = api.sandbox.get_bill_of_lading("shipmentId")

        assert_predicate(res.status, :success?)
      end

      def test_get_shipments
        res = api.sandbox.get_shipments("SHIPMENT", "ATVPDKIKX0DER")

        assert_predicate(res.status, :success?)
      end

      def test_get_shipment_items_by_shipment_id
        res = api.sandbox.get_shipment_items_by_shipment_id("FBA15DJ9SVVD", marketplace_id: "ATVPDKIKX0DER")

        assert_predicate(res.status, :success?)
      end

      def test_get_shipment_items
        res = api.sandbox.get_shipment_items("SHIPMENT", "ATVPDKIKX0DER", next_token: "NextToken")

        assert_predicate(res.status, :success?)
      end
    end
  end
end
