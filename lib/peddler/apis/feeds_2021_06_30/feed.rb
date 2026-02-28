# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class Feeds20210630
      # Detailed information about the feed.
      Feed = Structure.new do
        # @return [Time] The date and time when the feed was created, in ISO 8601 date time format.
        attribute(:created_time, Time, null: false, from: "createdTime")

        # @return [String] The identifier for the feed. This identifier is unique only in combination with a seller ID.
        attribute(:feed_id, String, null: false, from: "feedId")

        # @return [String] The feed type.
        attribute(:feed_type, String, null: false, from: "feedType")

        # @return [String] The processing status of the feed.
        attribute(:processing_status, String, null: false, from: "processingStatus")

        # @return [Array<String>] A list of identifiers for the marketplaces that the feed is applied to.
        attribute?(:marketplace_ids, [String], from: "marketplaceIds")

        # @return [Time] The date and time when feed processing completed, in ISO 8601 date time format.
        attribute?(:processing_end_time, Time, from: "processingEndTime")

        # @return [Time] The date and time when feed processing started, in ISO 8601 date time format.
        attribute?(:processing_start_time, Time, from: "processingStartTime")

        # @return [String] The identifier for the feed document. This identifier is unique only in combination with a
        #   seller ID.
        attribute?(:result_feed_document_id, String, from: "resultFeedDocumentId")
      end
    end
  end
end
