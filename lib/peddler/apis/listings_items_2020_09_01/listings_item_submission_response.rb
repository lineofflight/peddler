# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ListingsItems20200901
      # Response containing the results of a submission to the Selling Partner API for Listings Items.
      ListingsItemSubmissionResponse = Structure.new do
        # @return [String] A selling partner provided identifier for an Amazon listing.
        attribute(:sku, String)

        # @return [String] The status of the listings item submission.
        attribute(:status, String)

        # @return [String] The unique identifier of the listings item submission.
        attribute(:submission_id, String, from: "submissionId")

        # @return [Array<Issue>] Listings item issues related to the listings item submission.
        attribute?(:issues, [Issue])
      end
    end
  end
end
