# frozen_string_literal: true

require "helper"

module Peddler
  module APIs
    class DataKiosk20231115Test < Minitest::Test
      include FeatureHelpers

      def test_get_queries
        res = api.get_queries(page_size: 1, processing_statuses: ["DONE", "IN_PROGRESS"])

        assert_success(res)
      end

      def test_create_query
        res = api.create_query(body: { "query" => "query {sampleQuery(startDate:\"2023-03-01\" endDate:\"2023-03-31\" marketplaceIds:[\"ATVPDKIKX0DER\"]){sales{date averageSellingPrice{amount currencyCode}}}}" })

        assert_success(res)
      end

      def test_cancel_query
        res = api.cancel_query(query_id: "QueryId1")

        assert_success(res)
      end

      def test_get_query
        res = api.get_query(query_id: "QueryId1")

        assert_success(res)
      end

      def test_get_document
        res = api.get_document(document_id: "DocumentId1")

        assert_success(res)
      end
    end
  end
end
