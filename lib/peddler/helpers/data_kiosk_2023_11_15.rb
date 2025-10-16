# frozen_string_literal: true

require "http"

module Peddler
  module Helpers
    module DataKiosk20231115
      # Convenience method to download a Data Kiosk document by its document ID or URL.
      # This method can handle both document IDs and direct download URLs.
      #
      # @param document_id_or_url [String] The document identifier or download URL
      # @return [Peddler::Response] The API response containing the document content
      def download_query_document(document_id_or_url)
        # If it looks like a URL, use direct download
        if document_id_or_url.start_with?("http")
          return download_query_document_from_url(document_id_or_url)
        end

        # Otherwise, treat it as a document ID and get the download URL first
        response = get_document(document_id_or_url)
        document_url = response.parse.document_url

        download_query_document_from_url(document_url)
      end

      private

      def download_query_document_from_url(document_url)
        http_response = HTTP.use(:auto_inflate).get(document_url)
        Response.wrap(http_response)
      end
    end
  end
end
