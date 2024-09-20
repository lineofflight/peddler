# frozen_string_literal: true

require "helper"

require "peddler/api/reports_2021_06_30"

module Peddler
  class API
    class Reports20210630Test < Minitest::Test
      def setup
        super
        @api = Reports20210630.new(aws_region, request_access_token)
      end

      def test_create_report
        res = @api.create_report(
          {
            "reportType" => "GET_MERCHANTS_LISTINGS_FYP_REPORT",
            "marketplaceIds" => ["A1F83G8C2ARO7P"],
          },
        )

        assert_predicate(res.status, :accepted?)
      end

      def test_get_reports
        res = @api.get_reports(report_types: ["GET_MERCHANTS_LISTINGS_FYP_REPORT"])

        assert_predicate(res.status, :ok?)
      end

      def test_get_report
        res = @api.get_report("123")

        assert_predicate(res.status, :ok?)
      end

      def test_get_report_document
        res = @api.get_report_document("amzn1.spdoc.123")

        assert_predicate(res.status, :ok?)
      end
    end
  end
end
