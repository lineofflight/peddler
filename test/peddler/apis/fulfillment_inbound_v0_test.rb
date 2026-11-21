# frozen_string_literal: true

require "helper"

module Peddler
  module APIs
    class FulfillmentInboundV0Test < Minitest::Test
      include FeatureHelpers

      def test_get_prep_instructions
        res = api.get_prep_instructions("US", asin_list: ["ASIN1"])

        assert_success(res)
      end

      def test_get_labels
        res = api.get_labels("348975493", "PackageLabel_Letter_2", "BARCODE_2D")

        assert_success(res)
      end

      def test_get_bill_of_lading
        res = api.get_bill_of_lading("shipmentId")

        assert_success(res)
      end

      def test_get_shipments
        res = api.get_shipments("SHIPMENT", "ATVPDKIKX0DER")

        assert_success(res, typed: false)
      end

      def test_get_shipment_items_by_shipment_id
        res = api.get_shipment_items_by_shipment_id("FBA15DJ9SVVD", marketplace_id: "ATVPDKIKX0DER")

        assert_success(res)
      end

      def test_get_shipment_items
        res = api.get_shipment_items("SHIPMENT", "ATVPDKIKX0DER", next_token: "NextToken")

        assert_success(res)
      end
    end
  end
end
