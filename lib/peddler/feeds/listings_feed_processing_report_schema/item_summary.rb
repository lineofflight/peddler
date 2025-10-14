# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Feeds
    module ListingsFeedProcessingReportSchema
      # Aggregate counts of items, errors, and warnings related to the listing items created or updated by this feed
      # submission and included in the Items section of this report.
      ItemSummary = Structure.new do
        # @return [Integer] Number of errors across all listing items created or updated by this feed submission.
        attribute(:errors, Integer)

        # @return [Integer] Number of listing items created or updated by this feed submission and included in the Items
        # section of this report.
        attribute(:items, Integer)

        # @return [Integer] Number of warnings across all listing items created or updated by this feed submission.
        attribute(:warnings, Integer)
      end
    end
  end
end
