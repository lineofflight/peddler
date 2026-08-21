# frozen_string_literal: true

require "http"

module Peddler
  module Helpers
    module Reports20210630
      # Convenience method to download a report by its document ID or URL.
      # This method can handle both document IDs and direct download URLs.
      #
      # Given a document ID, the report is fetched with Amazon's `enableContentEncodingUrlHeader` option and
      # decompressed transparently, so the response body is the report content even when Amazon compresses it.
      # Given a URL, the body is decompressed only if the URL was obtained with that option; otherwise it is the
      # raw bytes Amazon serves.
      #
      # @param report_document_id_or_url [String] The report document identifier or download URL
      # @return [Peddler::Response] The API response containing the report content
      def download_report_document(report_document_id_or_url)
        # If it looks like a URL, use direct download
        if report_document_id_or_url.start_with?("http")
          return download_report_document_from_url(report_document_id_or_url)
        end

        # Otherwise, treat it as a document ID and get the download URL first
        document_info = get_report_document(report_document_id_or_url, enable_content_encoding_url_header: true)
        download_url = document_info.dig("url")

        download_report_document_from_url(download_url)
      end

      private

      def download_report_document_from_url(download_url)
        http_response = HTTP.use(:auto_inflate).get(download_url)
        Response.wrap(http_response)
      end
    end
  end
end
