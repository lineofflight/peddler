# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/api"

module Peddler
  class << self
    def aplus_content_2020_11_01(...)
      APIs::AplusContent20201101.new(...)
    end
  end

  module APIs
    # Selling Partner API for A+ Content Management
    #
    # Use the A+ Content API to build applications that help selling partners add rich marketing content to their Amazon
    # product detail pages. Selling partners can use A+ content to share their brand and product story, which helps
    # buyers make informed purchasing decisions. Selling partners use content modules to add images and text.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/aplus-content-api-model/aplusContent_2020-11-01.json
    class AplusContent20201101 < API
      # Returns a list of all A+ Content documents, including metadata, that are assigned to a selling partner. To get
      # the actual contents of the A+ Content documents, call the `getContentDocument` operation.
      #
      # @param marketplace_id [String] The marketplace ID is the globally unique identifier of a marketplace. To find
      #   the ID for your marketplace, refer to [Marketplace
      #   IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
      # @param page_token [String] A token that you use to fetch a specific page when there are multiple pages of
      #   results.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def search_content_documents(marketplace_id, page_token: nil, rate_limit: 10.0)
        cannot_sandbox!

        path = "/aplus/2020-11-01/contentDocuments"
        params = {
          "marketplaceId" => marketplace_id,
          "pageToken" => page_token,
        }.compact
        parser = Peddler::Types::AplusContent20201101::SearchContentDocumentsResponse if typed?
        meter(rate_limit).get(path, params:, parser:)
      end

      # Creates a new A+ Content document.
      #
      # @param marketplace_id [String] The marketplace ID is the globally unique identifier of a marketplace. To find
      #   the ID for your marketplace, refer to [Marketplace
      #   IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
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
        parser = Peddler::Types::AplusContent20201101::PostContentDocumentResponse if typed?
        meter(rate_limit).post(path, body:, params:, parser:)
      end

      # Returns an A+ Content document, if available.
      #
      # @param content_reference_key [String] The unique reference key for the A+ Content document. A content reference
      #   key cannot form a permalink and might change in the future. A content reference key is not guaranteed to match
      #   any A+ Content identifier.
      # @param marketplace_id [String] The marketplace ID is the globally unique identifier of a marketplace. To find
      #   the ID for your marketplace, refer to [Marketplace
      #   IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
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
        parser = Peddler::Types::AplusContent20201101::GetContentDocumentResponse if typed?
        meter(rate_limit).get(path, params:, parser:)
      end

      # Updates an existing A+ Content document.
      #
      # @param content_reference_key [String] The unique reference key for the A+ Content document. A content reference
      #   key cannot form a permalink and might change in the future. A content reference key is not guaranteed to match
      #   any A+ Content identifier.
      # @param marketplace_id [String] The marketplace ID is the globally unique identifier of a marketplace. To find
      #   the ID for your marketplace, refer to [Marketplace
      #   IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
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
        parser = Peddler::Types::AplusContent20201101::PostContentDocumentResponse if typed?
        meter(rate_limit).post(path, body:, params:, parser:)
      end

      # Returns a list of ASINs that are related to the specified A+ Content document, if available. If you don't
      # include the `asinSet` parameter, this operation returns all ASINs related to the content document.
      #
      # @param content_reference_key [String] The unique reference key for the A+ Content document. A content reference
      #   key cannot form a permalink and might change in the future. A content reference key is not guaranteed to match
      #   any A+ Content identifier.
      # @param marketplace_id [String] The marketplace ID is the globally unique identifier of a marketplace. To find
      #   the ID for your marketplace, refer to [Marketplace
      #   IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
      # @param included_data_set [Array<String>] The set of A+ Content data types to include in the response. If you
      #   don't include this parameter, the operation returns the related ASINs without metadata.
      # @param asin_set [Array<String>] The set of ASINs.
      # @param page_token [String] A token that you use to fetch a specific page when there are multiple pages of
      #   results.
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
        parser = Peddler::Types::AplusContent20201101::ListContentDocumentAsinRelationsResponse if typed?
        meter(rate_limit).get(path, params:, parser:)
      end

      # Replaces all ASINs related to the specified A+ Content document, if available. This operation can add or remove
      # ASINs, depending on the current set of related ASINs. Removing an ASIN will suspend the content document from
      # that ASIN.
      #
      # @param content_reference_key [String] The unique reference key for the A+ Content document. A content reference
      #   key cannot form a permalink and might change in the future. A content reference key is not guaranteed to match
      #   any A+ content identifier.
      # @param marketplace_id [String] The marketplace ID is the globally unique identifier of a marketplace. To find
      #   the ID for your marketplace, refer to [Marketplace
      #   IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
      # @param post_content_document_asin_relations_request [Hash] The request details for the content document ASIN
      #   relations.
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
        parser = Peddler::Types::AplusContent20201101::PostContentDocumentAsinRelationsResponse if typed?
        meter(rate_limit).post(path, body:, params:, parser:)
      end

      # Checks if the A+ Content document is valid for use on a set of ASINs.
      #
      # @param marketplace_id [String] The marketplace ID is the globally unique identifier of a marketplace. To find
      #   the ID for your marketplace, refer to [Marketplace
      #   IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
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
        parser = Peddler::Types::AplusContent20201101::ValidateContentDocumentAsinRelationsResponse if typed?
        meter(rate_limit).post(path, body:, params:, parser:)
      end

      # Searches for A+ Content publishing records, if available.
      #
      # @param marketplace_id [String] The marketplace ID is the globally unique identifier of a marketplace. To find
      #   the ID for your marketplace, refer to [Marketplace
      #   IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
      # @param asin [String] The Amazon Standard Identification Number (ASIN) is the unique identifier of a product
      #   within a marketplace.
      # @param page_token [String] A token that you use to fetch a specific page when there are multiple pages of
      #   results.
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
        parser = Peddler::Types::AplusContent20201101::SearchContentPublishRecordsResponse if typed?
        meter(rate_limit).get(path, params:, parser:)
      end

      # Submits an A+ Content document for review, approval, and publishing.
      #
      # @param content_reference_key [String] The unique reference key for the A+ Content document. A content reference
      #   key cannot form a permalink and might change in the future. A content reference key is not guaranteed to match
      #   any A+ content identifier.
      # @param marketplace_id [String] The marketplace ID is the globally unique identifier of a marketplace. To find
      #   the ID for your marketplace, refer to [Marketplace
      #   IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def post_content_document_approval_submission(content_reference_key, marketplace_id, rate_limit: 10.0)
        cannot_sandbox!

        path = "/aplus/2020-11-01/contentDocuments/#{percent_encode(content_reference_key)}/approvalSubmissions"
        params = {
          "marketplaceId" => marketplace_id,
        }.compact
        parser = Peddler::Types::AplusContent20201101::PostContentDocumentApprovalSubmissionResponse if typed?
        meter(rate_limit).post(path, params:, parser:)
      end

      # Submits a request to suspend visible A+ Content. This doesn't delete the content document or the ASIN relations.
      #
      # @param content_reference_key [String] The unique reference key for the A+ Content document. A content reference
      #   key cannot form a permalink and might change in the future. A content reference key is not guaranteed to match
      #   any A+ content identifier.
      # @param marketplace_id [String] The marketplace ID is the globally unique identifier of a marketplace. To find
      #   the ID for your marketplace, refer to [Marketplace
      #   IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def post_content_document_suspend_submission(content_reference_key, marketplace_id, rate_limit: 10.0)
        cannot_sandbox!

        path = "/aplus/2020-11-01/contentDocuments/#{percent_encode(content_reference_key)}/suspendSubmissions"
        params = {
          "marketplaceId" => marketplace_id,
        }.compact
        parser = Peddler::Types::AplusContent20201101::PostContentDocumentSuspendSubmissionResponse if typed?
        meter(rate_limit).post(path, params:, parser:)
      end

      private

      def load_types
        require "peddler/types/aplus_content_2020_11_01"
      end
    end
  end
end
