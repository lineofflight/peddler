# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ListingsItems20210801
      # Response containing the results of a submission to the Selling Partner API for Listings Items.
      ListingsItemSubmissionResponse = Structure.new do
        # A selling partner-provided identifier for an Amazon listing.
        attribute(:sku, String, null: false)

        # The status of the listings item submission. Known values: `ACCEPTED`, `INVALID`, `VALID`.
        attribute(:status, String, null: false)

        # The unique identifier of the listings item submission.
        attribute(:submission_id, String, null: false, from: "submissionId")

        # Identity attributes associated with the item in the Amazon catalog, such as the ASIN.
        attribute?(:identifiers, [ItemIdentifiersByMarketplace])

        # Listings item issues related to the listings item submission.
        attribute?(:issues, [Issue])
      end
    end
  end
end
