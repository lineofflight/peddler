# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/listings_items_2021_08_01/issue"
require "peddler/types/listings_items_2021_08_01/item_identifiers_by_marketplace"

module Peddler
  module Types
    module ListingsItems20210801
      # Response containing the results of a submission to the Selling Partner API for Listings Items.
      ListingsItemSubmissionResponse = Structure.new do
        # @return [String] A selling partner provided identifier for an Amazon listing.
        attribute(:sku, String)

        # @return [String] The status of the listings item submission.
        attribute(:status, String)

        # @return [String] The unique identifier of the listings item submission.
        attribute(:submission_id, String, from: "submissionId")

        # @return [Array<Issue>] Listings item issues related to the listings item submission.
        attribute(:issues, [Issue])

        # @return [Array<ItemIdentifiersByMarketplace>] Identity attributes associated with the item in the Amazon
        # catalog, such as the ASIN.
        attribute(:identifiers, [ItemIdentifiersByMarketplace])
      end
    end
  end
end
