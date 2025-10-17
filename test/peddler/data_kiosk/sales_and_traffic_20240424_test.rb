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

        response = api.create_query({ query: })
        query_id = response.parse.query_id

        response = api.get_query(query_id)
        parsed = response.parse

        data_document_id = parsed.data_document_id

        response = api.download_query_document(data_document_id)
        data = response.to_s.each_line.map do |line|
          payload = JSON.parse(line)
          DataKiosk::SalesAndTraffic20240424::SalesAndTrafficByDate.parse(payload)
        end

        refute_empty(data)
      end

      private

      def api_class
        APIs::DataKiosk20231115
      end

      def aws_region
        "us-east-1"
      end
    end
  end
end
