# frozen_string_literal: true

module Peddler
  module Helpers
    module Feeds20210630
      # Uploads feed_content to a signed upload_url previously provided by
      # create_feed_document. The upload_url is signed, the Host and content-type
      # headers must match the signing.
      # @param upload_url [String] The signed url from the `create_feed_document` response.
      # @param feed_content [String] The body of the content to upload.
      # @param content_type [String] The content type of the upload,
      # this must match the content-type requested in `create_feed_document`
      # @return [HTTP::Response] The API response
      def upload_feed_document(upload_url, feed_content, content_type)
        response = HTTP.headers(
          "Host" => URI.parse(upload_url).host,
          "content-type" => content_type,
        ).send(:put, upload_url, body: feed_content)

        if response.status.client_error?
          error = Error.build(response)
          raise error if error
        end

        response
      end
    end
  end
end
