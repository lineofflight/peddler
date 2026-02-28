# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Feeds
    module ListingsFeedProcessingReportSchema
      # Selling Partner JSON Listings Feed Processing Report (v2)
      Feed = Structure.new do
        # @return [Header] Header information about the feed submission.
        attribute(:header, Header, null: false)

        # @return [Array<Issue>] Issues containing message processing information for the Selling Partner.
        attribute(:issues, [Issue], null: false)

        # @return [Summary] Aggregate counts of errors, warnings, and statuses related to the acceptance of feed
        #   messages. When requested, Item Summary includes aggregate counts of items, errors, and warnings related to
        #   the listing items created or updated by this feed submission.
        attribute(:summary, Summary, null: false)

        # @return [Array<Object>] A set of listings items and their specific data sets that originates from the feed
        #   request’s "includedData" header parameter.
        attribute?(:items, Array)
      end
    end
  end
end
