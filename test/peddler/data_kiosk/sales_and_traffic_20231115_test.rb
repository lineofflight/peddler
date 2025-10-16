# frozen_string_literal: true

require "helper"

module Peddler
  module DataKiosk
    class SalesAndTraffic20231115Test < Minitest::Test
      include FeatureHelpers

      def test_workflow
        query = <<~GRAPHQL
          query {
            analytics_salesAndTraffic_2023_11_15 {
              salesAndTrafficByDate(
                startDate: "2025-04-01"
                endDate: "2025-06-30"
                marketplaceIds: ["A1805IZSGTT6HS"]
                aggregateBy: DAY
              ) {
                marketplaceId
                startDate
                endDate
                sales {
                  orderedProductSales {
                    amount
                    currencyCode
                  }
                  totalOrderItems
                  unitsOrdered
                }
                traffic {
                  pageViews
                  sessions
                  browserSessions
                }
              }
            }
          }
        GRAPHQL

        response = api.create_query({ query: })
        query_id = response.parse.query_id

        response = api.get_query(query_id)
        data_document_id = response.parse.data_document_id

        response = api.download_query_document(data_document_id)
        data = response.to_s.each_line.map do |line|
          payload = JSON.parse(line)
          DataKiosk::SalesAndTraffic20231115::SalesAndTrafficByDate.parse(payload)
        end

        refute_empty(data)
      end

      private

      def api_class
        APIs::DataKiosk20231115
      end
    end
  end
end
