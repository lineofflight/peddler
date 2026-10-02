# frozen_string_literal: true

require "helper"

module Peddler
  module APIs
    class FulfillmentInboundV0Test < Minitest::Test
      include FeatureHelpers

      def test_get_prep_instructions
        res = api.get_prep_instructions(ship_to_country_code: "US", asin_list: ["ASIN1"])

        assert_success(res)
      end

      def test_get_labels
        res = api.get_labels(shipment_id: "348975493", page_type: "PackageLabel_Letter_2", label_type: "BARCODE_2D")

        assert_success(res)
      end

      def test_get_bill_of_lading
        res = api.get_bill_of_lading(shipment_id: "shipmentId")

        assert_success(res)
      end

      def test_get_shipments
        res = api.get_shipments(query_type: "SHIPMENT", marketplace_id: "ATVPDKIKX0DER")

        assert_success(res, typed: false)
      end

      def test_get_shipment_items_by_shipment_id
        res = api.get_shipment_items_by_shipment_id(shipment_id: "FBA15DJ9SVVD", marketplace_id: "ATVPDKIKX0DER")

        assert_success(res)
      end

      def test_get_shipment_items
        res = api.get_shipment_items(query_type: "SHIPMENT", marketplace_id: "ATVPDKIKX0DER", next_token: "NextToken")

        assert_success(res)
      end
    end
  end
end
