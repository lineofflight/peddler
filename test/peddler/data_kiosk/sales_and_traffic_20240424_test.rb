# frozen_string_literal: true

require "helper"

module Peddler
  module DataKiosk
    class SalesAndTraffic20240424Test < Minitest::Test
      include FeatureHelpers

      def test_sales_and_traffic_by_date_query
        query = <<~GRAPHQL
          query {
            analytics_salesAndTraffic_2024_04_24 {
              salesAndTrafficByDate(
                startDate: "2025-01-01"
                endDate: "2025-06-30"
                marketplaceIds: ["ATVPDKIKX0DER"]
                aggregateBy: WEEK
              ) {
                marketplaceId
                startDate
                endDate
                sales {
                  orderedProductSales {
                    amount
                    currencyCode
                  }
                  shippedProductSales {
                    amount
                    currencyCode
                  }
                  averageSellingPrice {
                    amount
                    currencyCode
                  }
                  averageSalesPerOrderItem {
                    amount
                    currencyCode
                  }
                  averageUnitsPerOrderItem
                  totalOrderItems
                  unitsOrdered
                  unitsShipped
                  unitsRefunded
                  ordersShipped
                  refundRate
                  claimsAmount {
                    amount
                    currencyCode
                  }
                  claimsGranted
                }
                traffic {
                  pageViews
                  sessions
                  browserPageViews
                  browserSessions
                  mobileAppPageViews
                  mobileAppSessions
                  buyBoxPercentage
                  unitSessionPercentage
                  orderItemSessionPercentage
                  averageOfferCount
                  averageParentItems
                  feedbackReceived
                  negativeFeedbackReceived
                  receivedNegativeFeedbackRate
                }
              }
            }
          }
        GRAPHQL

        response = api.create_query(body: { query: })
        query_id = response.parse.query_id

        response = api.get_query(query_id: query_id)
        parsed = response.parse

        data_document_id = parsed.data_document_id

        url = api.get_document(document_id: data_document_id).parse.document_url
        data = client.download_document(replayed(url)).each_jsonl.map do |payload|
          DataKiosk::SalesAndTraffic20240424::SalesAndTrafficByDate.parse(payload)
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
