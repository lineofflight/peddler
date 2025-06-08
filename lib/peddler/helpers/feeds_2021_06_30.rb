# frozen_string_literal: true

require "http"

require "peddler/response"

module Peddler
  module Helpers
    module Feeds20210630
      # Convenience method to upload feed content to a signed upload_url previously
      # provided by create_feed_document. This is step 2 of the 6-step Feeds API workflow.
      # See README.md for the complete workflow documentation.
      #
      # The upload_url is signed, the Host and content-type headers must match the signing.
      # @param upload_url [String] The signed url from the `create_feed_document` response.
      # @param feed_content [String] The body of the content to upload.
      # @param content_type [String] The content type of the upload,
      # this must match the content-type requested in `create_feed_document`
      # @return [HTTP::Response] The API response
      def upload_feed_document(upload_url, feed_content, content_type)
        response = HTTP.headers("content-type" => content_type).put(upload_url, body: feed_content)

        Response.wrap(response, parser:)
      end

      # Convenience method to download result feed content from a signed download_url
      # provided by get_feed_document. This is step 6 of the 6-step Feeds API workflow.
      # See README.md for the complete workflow documentation.
      #
      # The download_url is signed and provides access to the processed feed results.
      # @param download_url [String] The signed url from the `get_feed_document` response.
      # @return [HTTP::Response] The API response containing the feed result document
      def download_result_feed_document(download_url)
        response = HTTP.get(download_url)

        Response.wrap(response, parser:)
      end
    end
  end
end
