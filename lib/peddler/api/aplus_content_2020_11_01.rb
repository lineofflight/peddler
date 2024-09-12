# frozen_string_literal: true

require "peddler/api"

module Peddler
  class API
    # Selling Partner API for A+ Content Management
    #
    # With the A+ Content API, you can build applications that help selling partners add rich marketing content to their
    # Amazon product detail pages. A+ content helps selling partners share their brand and product story, which helps
    # buyers make informed purchasing decisions. Selling partners assemble content by choosing from content modules and
    # adding images and text.
    class AplusContent20201101 < API
      # Returns a list of all A+ Content documents assigned to a selling partner. This operation returns only the
      # metadata of the A+ Content documents. Call the getContentDocument operation to get the actual contents of the A+
      # Content documents.
      #
      # @param [String] marketplace_id The identifier for the marketplace where the A+ Content is published.
      # @param [String] page_token A page token from the nextPageToken response element returned by your previous call
      #   to this operation. nextPageToken is returned when the results of a call exceed the page size. To get the next
      #   page of results, call the operation and include pageToken as the only parameter. Specifying pageToken with any
      #   other parameter will cause the request to fail. When no nextPageToken value is returned there are no more
      #   pages to return. A pageToken value is not usable across different operations.
      # @return [Hash] The API response
      def search_content_documents(marketplace_id, page_token: nil)
        path = "/aplus/2020-11-01/contentDocuments"
        params = {
          "marketplaceId" => marketplace_id,
          "pageToken" => page_token,
        }.compact

        rate_limit(0.1).get(path, params:)
      end

      # Creates a new A+ Content document.
      #
      # @param [String] marketplace_id The identifier for the marketplace where the A+ Content is published.
      # @param [Hash] post_content_document_request The content document request details.
      # @return [Hash] The API response
      def create_content_document(marketplace_id, post_content_document_request)
        path = "/aplus/2020-11-01/contentDocuments"
        body = post_content_document_request
        params = {
          "marketplaceId" => marketplace_id,
        }.compact

        rate_limit(0.1).post(path, body:, params:)
      end

      # Returns an A+ Content document, if available.
      #
      # @param [String] content_reference_key The unique reference key for the A+ Content document. A content reference
      #   key cannot form a permalink and may change in the future. A content reference key is not guaranteed to match
      #   any A+ Content identifier.
      # @param [String] marketplace_id The identifier for the marketplace where the A+ Content is published.
      # @param [Array<String>] included_data_set The set of A+ Content data types to include in the response.
      # @return [Hash] The API response
      def get_content_document(content_reference_key, marketplace_id, included_data_set)
        path = "/aplus/2020-11-01/contentDocuments/#{content_reference_key}"
        params = {
          "marketplaceId" => marketplace_id,
          "includedDataSet" => included_data_set,
        }.compact

        rate_limit(0.1).get(path, params:)
      end

      # Updates an existing A+ Content document.
      #
      # @param [String] content_reference_key The unique reference key for the A+ Content document. A content reference
      #   key cannot form a permalink and may change in the future. A content reference key is not guaranteed to match
      #   any A+ Content identifier.
      # @param [String] marketplace_id The identifier for the marketplace where the A+ Content is published.
      # @param [Hash] post_content_document_request The content document request details.
      # @return [Hash] The API response
      def update_content_document(content_reference_key, marketplace_id, post_content_document_request)
        path = "/aplus/2020-11-01/contentDocuments/#{content_reference_key}"
        body = post_content_document_request
        params = {
          "marketplaceId" => marketplace_id,
        }.compact

        rate_limit(0.1).post(path, body:, params:)
      end

      # Returns a list of ASINs related to the specified A+ Content document, if available. If you do not include the
      # asinSet parameter, the operation returns all ASINs related to the content document.
      #
      # @param [String] content_reference_key The unique reference key for the A+ Content document. A content reference
      #   key cannot form a permalink and may change in the future. A content reference key is not guaranteed to match
      #   any A+ Content identifier.
      # @param [String] marketplace_id The identifier for the marketplace where the A+ Content is published.
      # @param [Array<String>] included_data_set The set of A+ Content data types to include in the response. If you do
      #   not include this parameter, the operation returns the related ASINs without metadata.
      # @param [Array<String>] asin_set The set of ASINs.
      # @param [String] page_token A page token from the nextPageToken response element returned by your previous call
      #   to this operation. nextPageToken is returned when the results of a call exceed the page size. To get the next
      #   page of results, call the operation and include pageToken as the only parameter. Specifying pageToken with any
      #   other parameter will cause the request to fail. When no nextPageToken value is returned there are no more
      #   pages to return. A pageToken value is not usable across different operations.
      # @return [Hash] The API response
      def list_content_document_asin_relations(content_reference_key, marketplace_id, included_data_set: nil,
        asin_set: nil, page_token: nil)
        path = "/aplus/2020-11-01/contentDocuments/#{content_reference_key}/asins"
        params = {
          "marketplaceId" => marketplace_id,
          "includedDataSet" => included_data_set,
          "asinSet" => asin_set,
          "pageToken" => page_token,
        }.compact

        rate_limit(0.1).get(path, params:)
      end

      # Replaces all ASINs related to the specified A+ Content document, if available. This may add or remove ASINs,
      # depending on the current set of related ASINs. Removing an ASIN has the side effect of suspending the content
      # document from that ASIN.
      #
      # @param [String] content_reference_key The unique reference key for the A+ Content document. A content reference
      #   key cannot form a permalink and may change in the future. A content reference key is not guaranteed to match
      #   any A+ content identifier.
      # @param [String] marketplace_id The identifier for the marketplace where the A+ Content is published.
      # @param [Hash] post_content_document_asin_relations_request The content document ASIN relations request details.
      # @return [Hash] The API response
      def post_content_document_asin_relations(content_reference_key, marketplace_id,
        post_content_document_asin_relations_request)
        path = "/aplus/2020-11-01/contentDocuments/#{content_reference_key}/asins"
        body = post_content_document_asin_relations_request
        params = {
          "marketplaceId" => marketplace_id,
        }.compact

        rate_limit(0.1).post(path, body:, params:)
      end

      # Checks if the A+ Content document is valid for use on a set of ASINs.
      #
      # @param [String] marketplace_id The identifier for the marketplace where the A+ Content is published.
      # @param [Array<String>] asin_set The set of ASINs.
      # @param [Hash] post_content_document_request The content document request details.
      # @return [Hash] The API response
      def validate_content_document_asin_relations(marketplace_id, post_content_document_request, asin_set: nil)
        path = "/aplus/2020-11-01/contentAsinValidations"
        body = post_content_document_request
        params = {
          "marketplaceId" => marketplace_id,
          "asinSet" => asin_set,
        }.compact

        rate_limit(0.1).post(path, body:, params:)
      end

      # Searches for A+ Content publishing records, if available.
      #
      # @param [String] marketplace_id The identifier for the marketplace where the A+ Content is published.
      # @param [String] asin The Amazon Standard Identification Number (ASIN).
      # @param [String] page_token A page token from the nextPageToken response element returned by your previous call
      #   to this operation. nextPageToken is returned when the results of a call exceed the page size. To get the next
      #   page of results, call the operation and include pageToken as the only parameter. Specifying pageToken with any
      #   other parameter will cause the request to fail. When no nextPageToken value is returned there are no more
      #   pages to return. A pageToken value is not usable across different operations.
      # @return [Hash] The API response
      def search_content_publish_records(marketplace_id, asin, page_token: nil)
        path = "/aplus/2020-11-01/contentPublishRecords"
        params = {
          "marketplaceId" => marketplace_id,
          "asin" => asin,
          "pageToken" => page_token,
        }.compact

        rate_limit(0.1).get(path, params:)
      end

      # Submits an A+ Content document for review, approval, and publishing.
      #
      # @param [String] content_reference_key The unique reference key for the A+ Content document. A content reference
      #   key cannot form a permalink and may change in the future. A content reference key is not guaranteed to match
      #   any A+ content identifier.
      # @param [String] marketplace_id The identifier for the marketplace where the A+ Content is published.
      # @return [Hash] The API response
      def post_content_document_approval_submission(content_reference_key, marketplace_id)
        path = "/aplus/2020-11-01/contentDocuments/#{content_reference_key}/approvalSubmissions"
        params = {
          "marketplaceId" => marketplace_id,
        }.compact

        rate_limit(0.1).post(path, params:)
      end

      # Submits a request to suspend visible A+ Content. This neither deletes the content document nor the ASIN
      # relations.
      #
      # @param [String] content_reference_key The unique reference key for the A+ Content document. A content reference
      #   key cannot form a permalink and may change in the future. A content reference key is not guaranteed to match
      #   any A+ content identifier.
      # @param [String] marketplace_id The identifier for the marketplace where the A+ Content is published.
      # @return [Hash] The API response
      def post_content_document_suspend_submission(content_reference_key, marketplace_id)
        path = "/aplus/2020-11-01/contentDocuments/#{content_reference_key}/suspendSubmissions"
        params = {
          "marketplaceId" => marketplace_id,
        }.compact

        rate_limit(0.1).post(path, params:)
      end
    end
  end
end
