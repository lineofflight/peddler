# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module DataKioskQueryProcessingFinished
      # Notification payload data
      Payload = Structure.new do
        # @return [String] The merchant customer identifier or vendor group identifier of the selling partner account on
        # whose behalf the query was submitted.
        attribute(:account_id, String, from: "accountId")

        # @return [String] The processing status of the query.
        attribute(:processing_status, String, from: "processingStatus")

        # @return [String] The submitted query.
        attribute(:query, String)

        # @return [String] The query identifier. This identifier is unique only in combination with the `accountId`.
        attribute(:query_id, String, from: "queryId")

        # @return [String] The data document identifier. This document identifier is only present when there is data
        # available as a result of the query. This identifier is unique only in combination with the `accountId`. Pass
        # this identifier into the `getDocument` operation to get the information required to retrieve the data
        # document's contents.
        attribute?(:data_document_id, String, from: "dataDocumentId")

        # @return [String] The error document identifier. This document identifier is only present when an error occurs
        # during query processing. This identifier is unique only in combination with the `accountId`. Pass this
        # identifier into the `getDocument` operation to get the information required to retrieve the error document's
        # contents.
        attribute?(:error_document_id, String, from: "errorDocumentId")

        # @return [Hash] When a query produces results that are not included in the data document, pagination occurs.
        # This means that results are divided into pages. To retrieve the next page, you must pass a
        # `CreateQuerySpecification` object with `paginationToken` set to this object's `nextToken` and with `query` set
        # to this object's `query` in the subsequent `createQuery` request. When there are no more pages to fetch, the
        # `nextToken` field will be absent.
        attribute?(:pagination, Hash)
      end
    end
  end
end
