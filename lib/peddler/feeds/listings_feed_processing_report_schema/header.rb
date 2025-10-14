# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Feeds
    module ListingsFeedProcessingReportSchema
      # Header information about the feed submission.
      Header = Structure.new do
        # @return [String] The identifier for the feed. This identifier is unique only in combination with a seller ID.
        attribute(:feed_id, String, from: "feedId")

        # @return [String] Identifier for the Selling Partner, such as the Merchant Account or Vendor Code.
        attribute(:seller_id, String, from: "sellerId")

        # @return [String] Version of the JSON Selling Partner Listings Feeds specification used for the feed
        # submission.
        attribute(:version, String)

        # @return [Report] The report information for the feed submission.
        attribute?(:report, Report)
      end
    end
  end
end
