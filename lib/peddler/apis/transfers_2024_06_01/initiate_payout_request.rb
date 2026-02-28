# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Transfers20240601
      # The request schema for the `initiatePayout` operation.
      InitiatePayoutRequest = Structure.new do
        # @return [String] The account type in the selected marketplace for which a payout must be initiated. For
        #   supported EU marketplaces, the only account type is `Standard Orders`.
        attribute(:account_type, String, null: false, from: "accountType")

        # @return [String] The identifier of the Amazon marketplace. This API supports the following marketplaces: DE,
        #   FR, IT, ES, SE, NL, PL, and BE. For a list of possible marketplace IDs, refer to [Marketplace
        #   IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")
      end
    end
  end
end
