# frozen_string_literal: true

require "http"
require "peddler/error"

module Peddler
  module Helpers
    module Reports20210630
      # Convenience method to download a report by its document ID or URL.
      # This method can handle both document IDs and direct download URLs.
      #
      # @param report_document_id_or_url [String] The report document identifier or download URL
      # @return [HTTP::Response] The API response containing the report content
      def download_report_document(report_document_id_or_url)
        # If it looks like a URL, use direct download
        if report_document_id_or_url.start_with?("http")
          return download_report_document_from_url(report_document_id_or_url)
        end

        # Otherwise, treat it as a document ID and get the download URL first
        document_info = get_report_document(report_document_id_or_url)
        download_url = document_info.dig("url")
        
        download_report_document_from_url(download_url)
      end

      private

      # Downloads report content from a signed download_url previously provided by
      # get_report_document. This is step 2 of the Reports API workflow.
      # See https://developer-docs.amazon.com/sp-api/docs/reports-api-v2021-06-30-retrieve-a-report
      #
      # The download_url is signed and expires after 5 minutes.
      # @param download_url [String] The signed url from the `get_report_document` response.
      # @return [HTTP::Response] The API response containing the report content
      def download_report_document_from_url(download_url)
        response = HTTP.get(download_url)

        if response.status.client_error?
          error = Error.build(response)
          raise error if error
        end

        response
      end
    end
  end
end
