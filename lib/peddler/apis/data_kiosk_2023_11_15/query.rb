# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class DataKiosk20231115
      # Detailed information about the query.
      Query = Structure.new do
        # @return [Time] The date and time when the query was created, in ISO 8601 date time format.
        attribute(:created_time, Time, from: "createdTime")

        # @return [String] The processing status of the query.
        attribute(:processing_status, String, from: "processingStatus")

        # @return [String] The submitted query.
        attribute(:query, String)

        # @return [String] The query identifier. This identifier is unique only in combination with a selling partner
        #   account ID.
        attribute(:query_id, String, from: "queryId")

        # @return [String] The data document identifier. This identifier is only present when there is data available as
        #   a result of the query. This identifier is unique only in combination with a selling partner account ID. Pass
        #   this identifier into the `getDocument` operation to get the information required to retrieve the data
        #   document's contents.
        attribute?(:data_document_id, String, from: "dataDocumentId")

        # @return [String] The error document identifier. This identifier is only present when an error occurs during
        #   query processing. This identifier is unique only in combination with a selling partner account ID. Pass this
        #   identifier into the `getDocument` operation to get the information required to retrieve the error document's
        #   contents.
        attribute?(:error_document_id, String, from: "errorDocumentId")

        # @return [Hash] When a query produces results that are not included in the data document, pagination occurs.
        #   This means the results are divided into pages. To retrieve the next page, you must pass a
        #   `CreateQuerySpecification` object with `paginationToken` set to this object's `nextToken` and with `query`
        #   set to this object's `query` in the subsequent `createQuery` request. When there are no more pages to fetch,
        #   the `nextToken` field will be absent.
        attribute?(:pagination, Hash)

        # @return [Time] The date and time when the query processing completed, in ISO 8601 date time format.
        attribute?(:processing_end_time, Time, from: "processingEndTime")

        # @return [Time] The date and time when the query processing started, in ISO 8601 date time format.
        attribute?(:processing_start_time, Time, from: "processingStartTime")
      end
    end
  end
end
