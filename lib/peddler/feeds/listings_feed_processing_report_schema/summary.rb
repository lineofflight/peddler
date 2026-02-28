# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Feeds
    module ListingsFeedProcessingReportSchema
      # Aggregate counts of errors, warnings, and statuses related to the acceptance of feed messages. When requested,
      # Item Summary includes aggregate counts of items, errors, and warnings related to the listing items created or
      # updated by this feed submission.
      Summary = Structure.new do
        # @return [Integer] Number of errors encountered processing the feed.
        attribute(:errors, Integer, null: false)

        # @return [Integer] Number of messages that were accepted, the associated updates are being applied.
        attribute(:messages_accepted, Integer, null: false, from: "messagesAccepted")

        # @return [Integer] Number of messages that were invalid, the associated updates will not be applied.
        attribute(:messages_invalid, Integer, null: false, from: "messagesInvalid")

        # @return [Integer] Number of messages processed.
        attribute(:messages_processed, Integer, null: false, from: "messagesProcessed")

        # @return [Integer] Number of warnings encountered processing the feed.
        attribute(:warnings, Integer, null: false)

        # @return [ItemSummary] Aggregate counts of items, errors, and warnings related to the listing items created or
        #   updated by this feed submission and included in the Items section of this report.
        attribute?(:item_summary, ItemSummary, from: "itemSummary")
      end
    end
  end
end
