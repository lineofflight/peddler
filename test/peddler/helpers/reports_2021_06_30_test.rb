# frozen_string_literal: true

require "helper"
require "peddler/apis/reports_2021_06_30"

module Peddler
  module Helpers
    class Reports20210630Test < Minitest::Test
      extend Forwardable
      include FeatureHelpers
      include Reports20210630

      def_delegator :api, :get_report_document

      def test_download_report_document_with_url
        url = "https://tortuga-prod-eu.s3-eu-west-1.amazonaws.com/123456"
        res = download_report_document(url)

        assert_predicate(res.status, :ok?)
      end

      def test_download_report_document_with_document_id
        document_id = "amzn1.spdoc.1.4.eu.123456"
        res = api.download_report_document(document_id)

        assert_predicate(res.status, :ok?)
      end

      def test_download_report_document_client_error
        stub_request(:get, /.*/)
          .to_return(status: 400,
            body: {
              "errors" => [{
                "code" => "Error",
              }],
            }.to_json)

        assert_raises(Peddler::Error) do
          download_report_document("https://example.com/report.csv")
        end
      end
    end
  end
end
