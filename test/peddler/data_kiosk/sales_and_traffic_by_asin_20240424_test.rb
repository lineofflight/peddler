# frozen_string_literal: true

require "helper"

module Peddler
  module DataKiosk
    class SalesAndTrafficByAsin20240424Test < Minitest::Test
      include FeatureHelpers

      def test_sales_and_traffic_by_asin_query
        query = <<~GRAPHQL
          query {
            analytics_salesAndTraffic_2024_04_24 {
              salesAndTrafficByAsin(
                startDate: "2025-01-01"
                endDate: "2025-06-30"
                marketplaceIds: ["ATVPDKIKX0DER"]
                aggregateBy: CHILD
              ) {
                marketplaceId
                startDate
                endDate
                parentAsin
                childAsin
                sku
                sales {
                  orderedProductSales {
                    amount
                    currencyCode
                  }
                  orderedProductSalesB2B {
                    amount
                    currencyCode
                  }
                  unitsOrdered
                  unitsOrderedB2B
                  totalOrderItems
                  totalOrderItemsB2B
                }
                traffic {
                  pageViews
                  pageViewsB2B
                  pageViewsPercentage
                  pageViewsPercentageB2B
                  sessions
                  sessionsB2B
                  sessionPercentage
                  sessionPercentageB2B
                  browserPageViews
                  browserPageViewsB2B
                  browserPageViewsPercentage
                  browserPageViewsPercentageB2B
                  browserSessions
                  browserSessionsB2B
                  browserSessionPercentage
                  browserSessionPercentageB2B
                  mobileAppPageViews
                  mobileAppPageViewsB2B
                  mobileAppPageViewsPercentage
                  mobileAppPageViewsPercentageB2B
                  mobileAppSessions
                  mobileAppSessionsB2B
                  mobileAppSessionPercentage
                  mobileAppSessionPercentageB2B
                  buyBoxPercentage
                  buyBoxPercentageB2B
                  unitSessionPercentage
                  unitSessionPercentageB2B
                }
              }
            }
          }
        GRAPHQL

        response = api.create_query(body: { query: })
        query_id = response.parse.query_id

        response = api.get_query(query_id: query_id)
        data_document_id = response.parse.data_document_id

        url = api.get_document(document_id: data_document_id).parse.document_url
        data = client.download_document(replayed(url)).each_jsonl.map do |payload|
          DataKiosk::SalesAndTraffic20240424::SalesAndTrafficByASIN.parse(payload)
        end

        refute_empty(data)
      end

      private

      def api_name
        "data_kiosk_2023_11_15"
      end
    end
  end
end
