# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module Feeds20210630
      # Detailed information about the feed.
      Feed = Structure.new do
        # @return [String] The date and time when the feed was created, in ISO 8601 date time format.
        attribute(:created_time, String, from: "createdTime")

        # @return [String] The identifier for the feed. This identifier is unique only in combination with a seller ID.
        attribute(:feed_id, String, from: "feedId")

        # @return [String] The feed type.
        attribute(:feed_type, String, from: "feedType")

        # @return [String] The processing status of the feed.
        attribute(:processing_status, String, from: "processingStatus")

        # @return [Array<String>] A list of identifiers for the marketplaces that the feed is applied to.
        attribute?(:marketplace_ids, [String], from: "marketplaceIds")

        # @return [String] The date and time when feed processing completed, in ISO 8601 date time format.
        attribute?(:processing_end_time, String, from: "processingEndTime")

        # @return [String] The date and time when feed processing started, in ISO 8601 date time format.
        attribute?(:processing_start_time, String, from: "processingStartTime")

        # @return [String] The identifier for the feed document. This identifier is unique only in combination with a
        # seller ID.
        attribute?(:result_feed_document_id, String, from: "resultFeedDocumentId")
      end
    end
  end
end
