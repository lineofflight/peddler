# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # Selling Partner API for A+ Content Management
    #
    # With the A+ Content API, you can build applications that help selling partners add rich marketing content to their
    # Amazon product detail pages. A+ Content helps selling partners share their brand and product story, which helps
    # buyers make informed purchasing decisions. Selling partners assemble content by choosing from content modules and
    # adding images and text.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/aplus-content-api-model/aplusContent_2020-11-01.json
    class AplusContent20201101 < API
      # Retrieve a list of all A+ Content documents assigned to a selling partner. This operation returns only the
      # metadata of the A+ Content documents. Call the `getContentDocument` operation to get the actual contents of the
      # A+ Content documents.
      #
      # @param marketplace_id [String] The identifier for the Amazon store where the A+ Content is published.
      # @param page_token [String] A page token from the `nextPageToken` response element returned by your previous call
      #   to this operation. `nextPageToken` is returned when the results of a call exceed the page size. To get the
      #   next page of results, call the operation and include `pageToken` as the only parameter. Specifying `pageToken`
      #   with any other parameter will cause the request to fail. When no `nextPageToken` value is returned there are
      #   no more pages to return. A `pageToken` value is not usable across different operations.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def search_content_documents(marketplace_id, page_token: nil, rate_limit: 10.0)
        cannot_sandbox!

        path = "/aplus/2020-11-01/contentDocuments"
        params = {
          "marketplaceId" => marketplace_id,
          "pageToken" => page_token,
        }.compact
        parser = -> { SearchContentDocumentsResponse }
        get(path, params:, rate_limit:, parser:)
      end

      # Create a new A+ Content document.
      #
      # @param marketplace_id [String] The identifier for the Amazon store where the A+ Content is published.
      # @param post_content_document_request [Hash] The content document request details.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def create_content_document(marketplace_id, post_content_document_request, rate_limit: 10.0)
        cannot_sandbox!

        path = "/aplus/2020-11-01/contentDocuments"
        body = post_content_document_request
        params = {
          "marketplaceId" => marketplace_id,
        }.compact
        parser = -> { PostContentDocumentResponse }
        post(path, body:, params:, rate_limit:, parser:)
      end

      # Retrieve an A+ Content document, if available.
      #
      # @param content_reference_key [String] The unique reference key for the A+ Content document. A content reference
      #   key cannot form a permalink and may change in the future. A content reference key is not guaranteed to match
      #   any A+ Content identifier.
      # @param marketplace_id [String] The identifier for the Amazon store where the A+ Content is published.
      # @param included_data_set [Array<String>] The set of A+ Content data types to include in the response.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_content_document(content_reference_key, marketplace_id, included_data_set, rate_limit: 10.0)
        cannot_sandbox!

        path = "/aplus/2020-11-01/contentDocuments/#{percent_encode(content_reference_key)}"
        params = {
          "marketplaceId" => marketplace_id,
          "includedDataSet" => stringify_array(included_data_set),
        }.compact
        parser = -> { GetContentDocumentResponse }
        get(path, params:, rate_limit:, parser:)
      end

      # Update an existing A+ Content document.
      #
      # @param content_reference_key [String] The unique reference key for the A+ Content document. A content reference
      #   key cannot form a permalink and may change in the future. A content reference key is not guaranteed to match
      #   any A+ Content identifier.
      # @param marketplace_id [String] The identifier for the Amazon store where the A+ Content is published.
      # @param post_content_document_request [Hash] The content document request details.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def update_content_document(content_reference_key, marketplace_id, post_content_document_request,
        rate_limit: 10.0)
        cannot_sandbox!

        path = "/aplus/2020-11-01/contentDocuments/#{percent_encode(content_reference_key)}"
        body = post_content_document_request
        params = {
          "marketplaceId" => marketplace_id,
        }.compact
        parser = -> { PostContentDocumentResponse }
        post(path, body:, params:, rate_limit:, parser:)
      end

      # Retrieve a list of ASINs related to the specified A+ Content document, if available. If you do not include the
      # `asinSet` parameter, the operation returns all ASINs related to the content document.
      #
      # @param content_reference_key [String] The unique reference key for the A+ Content document. A content reference
      #   key cannot form a permalink and may change in the future. A content reference key is not guaranteed to match
      #   any A+ Content identifier.
      # @param marketplace_id [String] The identifier for the Amazon store where the A+ Content is published.
      # @param included_data_set [Array<String>] The set of A+ Content data types to include in the response. If you do
      #   not include this parameter, the operation returns the related ASINs without metadata.
      # @param asin_set [Array<String>] The set of ASINs.
      # @param page_token [String] A page token from the `nextPageToken` response element returned by your previous call
      #   to this operation. `nextPageToken` is returned when the results of a call exceed the page size. To get the
      #   next page of results, call the operation and include `pageToken` as the only parameter. Specifying `pageToken`
      #   with any other parameter will cause the request to fail. When no `nextPageToken` value is returned there are
      #   no more pages to return. A `pageToken` value is not usable across different operations.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def list_content_document_asin_relations(content_reference_key, marketplace_id, included_data_set: nil,
        asin_set: nil, page_token: nil, rate_limit: 10.0)
        cannot_sandbox!

        path = "/aplus/2020-11-01/contentDocuments/#{percent_encode(content_reference_key)}/asins"
        params = {
          "marketplaceId" => marketplace_id,
          "includedDataSet" => stringify_array(included_data_set),
          "asinSet" => stringify_array(asin_set),
          "pageToken" => page_token,
        }.compact
        parser = -> { ListContentDocumentASINRelationsResponse }
        get(path, params:, rate_limit:, parser:)
      end

      # Replaces all ASINs related to the specified A+ Content document, if available. This may add or remove ASINs,
      # depending on the current set of related ASINs. Removing an ASIN has the side effect of suspending the content
      # document from that ASIN.
      #
      # @param content_reference_key [String] The unique reference key for the A+ Content document. A content reference
      #   key cannot form a permalink and may change in the future. A content reference key is not guaranteed to match
      #   any A+ Content identifier.
      # @param marketplace_id [String] The identifier for the Amazon store where the A+ Content is published.
      # @param post_content_document_asin_relations_request [Hash] The content document ASIN relations request details.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def post_content_document_asin_relations(content_reference_key, marketplace_id,
        post_content_document_asin_relations_request, rate_limit: 10.0)
        cannot_sandbox!

        path = "/aplus/2020-11-01/contentDocuments/#{percent_encode(content_reference_key)}/asins"
        body = post_content_document_asin_relations_request
        params = {
          "marketplaceId" => marketplace_id,
        }.compact
        parser = -> { PostContentDocumentASINRelationsResponse }
        post(path, body:, params:, rate_limit:, parser:)
      end

      # Checks if the A+ Content document is valid for use on a set of ASINs.
      #
      # @param marketplace_id [String] The identifier for the Amazon store where the A+ Content is published.
      # @param asin_set [Array<String>] The set of ASINs.
      # @param post_content_document_request [Hash] The content document request details.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def validate_content_document_asin_relations(marketplace_id, post_content_document_request, asin_set: nil,
        rate_limit: 10.0)
        cannot_sandbox!

        path = "/aplus/2020-11-01/contentAsinValidations"
        body = post_content_document_request
        params = {
          "marketplaceId" => marketplace_id,
          "asinSet" => stringify_array(asin_set),
        }.compact
        parser = -> { ValidateContentDocumentASINRelationsResponse }
        post(path, body:, params:, rate_limit:, parser:)
      end

      # Searches for A+ Content publishing records, if available.
      #
      # @param marketplace_id [String] The identifier for the Amazon store where the A+ Content is published.
      # @param asin [String] The Amazon Standard Identification Number (ASIN).
      # @param page_token [String] A page token from the `nextPageToken` response element returned by your previous call
      #   to this operation. `nextPageToken` is returned when the results of a call exceed the page size. To get the
      #   next page of results, call the operation and include `pageToken` as the only parameter. Specifying `pageToken`
      #   with any other parameter will cause the request to fail. When no `nextPageToken` value is returned there are
      #   no more pages to return. A `pageToken` value is not usable across different operations.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def search_content_publish_records(marketplace_id, asin, page_token: nil, rate_limit: 10.0)
        cannot_sandbox!

        path = "/aplus/2020-11-01/contentPublishRecords"
        params = {
          "marketplaceId" => marketplace_id,
          "asin" => asin,
          "pageToken" => page_token,
        }.compact
        parser = -> { SearchContentPublishRecordsResponse }
        get(path, params:, rate_limit:, parser:)
      end

      # Submits an A+ Content document for review, approval, and publishing.
      #
      # @param content_reference_key [String] The unique reference key for the A+ Content document. A content reference
      #   key cannot form a permalink and may change in the future. A content reference key is not guaranteed to match
      #   any A+ Content identifier.
      # @param marketplace_id [String] The identifier for the Amazon store where the A+ Content is published.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def post_content_document_approval_submission(content_reference_key, marketplace_id, rate_limit: 10.0)
        cannot_sandbox!

        path = "/aplus/2020-11-01/contentDocuments/#{percent_encode(content_reference_key)}/approvalSubmissions"
        params = {
          "marketplaceId" => marketplace_id,
        }.compact
        parser = -> { PostContentDocumentApprovalSubmissionResponse }
        post(path, params:, rate_limit:, parser:)
      end

      # Submits a request to suspend visible A+ Content. This neither deletes the content document nor the ASIN
      # relations.
      #
      # @param content_reference_key [String] The unique reference key for the A+ Content document. A content reference
      #   key cannot form a permalink and may change in the future. A content reference key is not guaranteed to match
      #   any A+ Content identifier.
      # @param marketplace_id [String] The identifier for the Amazon store where the A+ Content is published.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def post_content_document_suspend_submission(content_reference_key, marketplace_id, rate_limit: 10.0)
        cannot_sandbox!

        path = "/aplus/2020-11-01/contentDocuments/#{percent_encode(content_reference_key)}/suspendSubmissions"
        params = {
          "marketplaceId" => marketplace_id,
        }.compact
        parser = -> { PostContentDocumentSuspendSubmissionResponse }
        post(path, params:, rate_limit:, parser:)
      end

      # Create a media asset record. The `mediaType` field determines the type of asset to create.
      #
      # This operation is idempotent; if the asset or pairing already exists with identical metadata, this operation
      # returns a `200` response with existing data. Returns `201` when a new asset or pairing is created. Returns `409`
      # if the asset or pairing already exists but the metadata fields differ.
      #
      # If an `uploadDestinationId` is provided, it is resolved to its `mediaId` before any further processing. A
      # request that references an asset by `uploadDestinationId` and a subsequent request that uses the resulting
      # `mediaId` are treated as referring to the same identity.
      #
      # @note This operation can make a static sandbox call.
      # @param create_media_request [Hash] The media creation request details.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def create_media(create_media_request, rate_limit: 10.0)
        path = "/aplus/2020-11-01/media"
        body = create_media_request
        parser = -> { CreateMediaResponse }
        post(path, body:, rate_limit:, parser:)
      end

      # Retrieve media metadata and related media for a given media ID. The response uses the unified Media shape.
      # Related media associations are also included in the response.
      #
      # When `associatedMediaId` is provided, `relatedMedia` is filtered to the specific pairing. When omitted, all
      # related media are returned.
      #
      # @note This operation can make a static sandbox call.
      # @param media_id [String] The unique identifier for the media asset.
      # @param associated_media_id [String] When provided, returns only the specific association. When omitted, returns
      #   all associated media.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_media(media_id, associated_media_id: nil, rate_limit: 10.0)
        path = "/aplus/2020-11-01/media/#{percent_encode(media_id)}"
        params = {
          "associatedMediaId" => associated_media_id,
        }.compact
        parser = -> { GetMediaResponse }
        get(path, params:, rate_limit:, parser:)
      end

      # Update metadata on an existing media asset. The `mediaId` path parameter identifies the target asset. For
      # video-image pairing title updates, provide `associatedMediaId` as a query parameter. For video-level description
      # updates or standalone image title updates, omit `associatedMediaId`.
      #
      # Each request updates either title or descriptions, but not both. Descriptions are upserted by locale; only
      # provided locales are modified, and existing locales not in the request are preserved.
      #
      # The response contains the full unified Media shape. When `associatedMediaId` is provided, `relatedMedia`
      # contains only the specified pairing. When `associatedMediaId` is absent, `relatedMedia` contains all affected
      # pairings.
      #
      # @note This operation can make a static sandbox call.
      # @param media_id [String] The unique identifier for the media asset to update.
      # @param associated_media_id [String] When provided, identifies the specific video-image pairing for title
      #   updates. Required when updating a pairing title.
      # @param update_media_request [Hash] The media update request details.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def update_media(media_id, update_media_request, associated_media_id: nil, rate_limit: 10.0)
        path = "/aplus/2020-11-01/media/#{percent_encode(media_id)}"
        body = update_media_request
        params = {
          "associatedMediaId" => associated_media_id,
        }.compact
        parser = -> { UpdateMediaResponse }
        patch(path, body:, params:, rate_limit:, parser:)
      end
    end
  end
end
