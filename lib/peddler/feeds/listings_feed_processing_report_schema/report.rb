# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Feeds
    module ListingsFeedProcessingReportSchema
      # The report information for the feed submission.
      Report = Structure.new do
        # @return [String] The version of the Selling Partner Listings Items API to use to retrieve the listing items.
        attribute(:api_version, String, from: "apiVersion")

        # @return [Array<String>] When "includedData" elements are in the feed submission, the processing report that
        # generates for the feed submission includes the listings items output from the Selling Partner Listings Items
        # API with the "includedData" elements from the request. The report includes issues that prevent the acceptance
        # of messages regardless of the "includedData" elements in the feed request.
        attribute(:included_data, [String], from: "includedData")
      end
    end
  end
end
