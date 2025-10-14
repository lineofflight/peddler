# frozen_string_literal: true

require "helper"

module Peddler
  module APIs
    class Reports20210630Test < Minitest::Test
      include FeatureHelpers

      def test_get_reports
        res = api.sandbox.get_reports(
          report_types: ["FEE_DISCOUNTS_REPORT", "GET_AFN_INVENTORY_DATA"],
          processing_statuses: ["IN_QUEUE", "IN_PROGRESS"],
        )

        assert_predicate(res.status, :success?)
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
        res = api.sandbox.create_report(payload)

        assert_predicate(res.status, :success?)
      end

      def test_get_report
        res = api.sandbox.get_report("ID323")

        assert_predicate(res.status, :success?)
      end

      def test_get_report_schedules
        res = api.sandbox.get_report_schedules(["FEE_DISCOUNTS_REPORT", "GET_FBA_FULFILLMENT_CUSTOMER_TAXES_DATA"])

        assert_predicate(res.status, :success?)
      end

      def test_create_report_schedule
        res = api.sandbox.create_report_schedule({
          "reportType" => "FEE_DISCOUNTS_REPORT",
          "period" => "PT5M",
          "nextReportCreationTime" => "2024-03-10T20:11:24.000Z",
          "marketplaceIds" => ["ATVPDKIKX0DER"],
        })

        assert_predicate(res.status, :success?)
      end

      def test_get_report_schedule
        res = api.sandbox.get_report_schedule("ID323")

        assert_predicate(res.status, :success?)
      end

      def test_get_report_document
        res = api.sandbox.get_report_document("0356cf79-b8b0-4226-b4b9-0ee058ea5760")

        assert_predicate(res.status, :success?)
      end
    end
  end
end
