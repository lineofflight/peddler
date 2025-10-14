# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module FeedProcessingFinished
      # Nested notification data
      FeedProcessingFinishedNotification = Structure.new do
        # @return [String] The merchant customer identifier or vendor group identifier of the selling partner account on
        # whose behalf the feed was submitted.
        attribute(:account_id, String, from: "accountId")

        # @return [String] The feed identifier.
        attribute(:feed_id, String, from: "feedId")

        # @return [String] The feed type.
        attribute(:feed_type, String, from: "feedType")

        # @return [String] The processing status of the feed.
        attribute(:processing_status, String, from: "processingStatus")

        # @return [String] The feed document identifier. This identifier is unique only in combination with a seller ID.
        attribute?(:result_feed_document_id, String, from: "resultFeedDocumentId")

        # @return [String] The merchant customer identifier of the selling partner account on whose behalf the feed was
        # submitted. This field will be null when the feed was submitted on behalf of a vendor group identifier.
        attribute?(:seller_id, String, from: "sellerId")
      end
    end
  end
end
