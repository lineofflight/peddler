# frozen_string_literal: true

require "helper"
require "peddler/apis/reports_2021_06_30"
require "csv"

module Peddler
  module Helpers
    class Reports20210630Test < Minitest::Test
      extend Forwardable
      include FeatureHelpers
      include Reports20210630

      def_delegators :api, :get_report_document, :parser

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

      def test_download_compressed_report_document
        url = "https://tortuga-prod-na.s3-external-1.amazonaws.com/123456"
        res = api.download_report_document(url)

        assert_predicate(res.status, :ok?)

        gzip = Zlib::GzipReader.new(res)
        opts = {
          col_sep: "\t",
          encoding: "#{res.charset}:UTF-8",
          headers: true,
          quote_char: "\x00",
        }
        data = CSV.parse(gzip, **opts)

        assert_kind_of(CSV::Table, data)
      end

      def test_download_report_document_client_error
        url = "https://tortuga-prod-na.s3-external-1.amazonaws.com/123456"

        begin
          require "nokogiri"
          # With nokogiri available, should parse XML error and raise Peddler::Error
          assert_raises(Peddler::Error) do
            download_report_document(url)
          end
        rescue LoadError
          # Without nokogiri, XML parsing fails gracefully - returns response instead of raising error
          result = download_report_document(url)

          assert_kind_of(Peddler::Response, result)
          assert_equal(403, result.status.code)
        end
      end
    end
  end
end
