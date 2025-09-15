# frozen_string_literal: true

require "helper"
require "peddler/apis/data_kiosk_2023_11_15"

module Peddler
  module APIs
    class DataKiosk20231115Test < Minitest::Test
      include FeatureHelpers

      def test_get_queries
        api.sandbox.get_queries(page_size: 1, processing_statuses: ["DONE", "IN_PROGRESS"])
      end

      def test_create_query
        api.sandbox.create_query({ "query" => "query {sampleQuery(startDate:\"2023-03-01\" endDate:\"2023-03-31\" marketplaceIds:[\"ATVPDKIKX0DER\"]){sales{date averageSellingPrice{amount currencyCode}}}}" })
      end

      def test_cancel_query
        api.sandbox.cancel_query("QueryId1")
      end

      def test_get_query
        api.sandbox.get_query("QueryId1")
      end

      def test_get_document
        api.sandbox.get_document("DocumentId1")
      end
    end
  end
end
