# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/api"

module Peddler
  class << self
    def uploads_2020_11_01(...)
      APIs::Uploads20201101.new(...)
    end
  end

  module APIs
    # Selling Partner API for Uploads
    #
    # The Uploads API lets you upload files that you can programmatically access using other Selling Partner APIs, such
    # as the A+ Content API and the Messaging API.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/uploads-api-model/uploads_2020-11-01.json
    class Uploads20201101 < API
      # Creates an upload destination, returning the information required to upload a file to the destination and to
      # programmatically access the file.
      #
      # @param marketplace_ids [Array<String>] The marketplace ID is the globally unique identifier of a marketplace. To
      #   find the ID for your marketplace, refer to [Marketplace
      #   IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
      # @param content_md5 [String] An MD5 hash of the content to be submitted to the upload destination. This value is
      #   used to determine if the data has been corrupted or tampered with during transit.
      # @param resource [String] The upload destination for your resource. For example, if you create an upload
      #   destination for the `createLegalDisclosure` operation of the Messaging API, the `{resource}` would be
      #   `/messaging/v1/orders/{amazonOrderId}/messages/legalDisclosure`, and the entire path would be
      #   `/uploads/2020-11-01/uploadDestinations/messaging/v1/orders/{amazonOrderId}/messages/legalDisclosure`. If you
      #   create an upload destination for an Aplus content document, the `{resource}` would be
      #   `aplus/2020-11-01/contentDocuments` and the path would be
      #   `/uploads/2020-11-01/uploadDestinations/aplus/2020-11-01/contentDocuments`.
      # @param content_type [String] The content type of the file you upload.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def create_upload_destination_for_resource(marketplace_ids, content_md5, resource, content_type: nil,
        rate_limit: 10.0)
        cannot_sandbox!

        path = "/uploads/2020-11-01/uploadDestinations/#{percent_encode(resource)}"
        params = {
          "marketplaceIds" => stringify_array(marketplace_ids),
          "contentMD5" => content_md5,
          "contentType" => content_type,
        }.compact
        parser = Peddler::Types::Uploads20201101::CreateUploadDestinationResponse if typed?
        meter(rate_limit).post(path, params:, parser:)
      end

      private

      def load_types
        require "peddler/types/uploads_2020_11_01"
      end
    end
  end
end
