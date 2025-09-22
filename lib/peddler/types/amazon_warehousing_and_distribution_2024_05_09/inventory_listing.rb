# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/amazon_warehousing_and_distribution_2024_05_09/inventory_summary"

module Peddler
  module Types
    module AmazonWarehousingAndDistribution20240509
      # AWD inventory payload.
      InventoryListing = Structure.new do
        # @return [Array<InventorySummary>] List of inventory summaries.
        attribute(:inventory, [InventorySummary])

        # @return [String] A token that is used to retrieve the next page of results. The response includes `nextToken`
        # when the number of results exceeds the specified `maxResults` value. To get the next page of results, call the
        # operation with this token and include the same arguments as the call that produced the token. To get a
        # complete list, call this operation until `nextToken` is null. Note that this operation can return empty pages.
        attribute(:next_token, String, from: "nextToken")
      end
    end
  end
end
