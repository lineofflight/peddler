# frozen_string_literal: true

require "helper"

module Peddler
  module APIs
    class Reports20210630Test < Minitest::Test
      include FeatureHelpers

      def test_get_reports
        res = api.get_reports(
          report_types: ["FEE_DISCOUNTS_REPORT", "GET_AFN_INVENTORY_DATA"],
          processing_statuses: ["IN_QUEUE", "IN_PROGRESS"],
        )

        assert_success(res)
      end

      def test_create_report
        payload = {
          "reportType": "GET_MERCHANT_LISTINGS_ALL_DATA",
          "dataStartTime": "2024-03-10T20:11:24.000Z",
          "marketplaceIds": [
            "A1PA6795UKMFR9",
            "ATVPDKIKX0DER",
          ],
        }
        res = api.create_report(body: payload)

        assert_success(res)
      end

      def test_get_report
        res = api.get_report(report_id: "ID323")

        assert_success(res)
      end

      def test_get_report_schedules
        res = api.get_report_schedules(report_types: ["FEE_DISCOUNTS_REPORT", "GET_FBA_FULFILLMENT_CUSTOMER_TAXES_DATA"])

        assert_success(res)
      end

      def test_create_report_schedule
        res = api.create_report_schedule(body: {
          "reportType" => "FEE_DISCOUNTS_REPORT",
          "period" => "PT5M",
          "nextReportCreationTime" => "2024-03-10T20:11:24.000Z",
          "marketplaceIds" => ["ATVPDKIKX0DER"],
        })

        assert_success(res)
      end

      def test_get_report_schedule
        res = api.get_report_schedule(report_schedule_id: "ID323")

        assert_success(res)
      end

      def test_get_report_document
        res = api.get_report_document(report_document_id: "0356cf79-b8b0-4226-b4b9-0ee058ea5760")

        assert_success(res)
      end
    end
  end
end
