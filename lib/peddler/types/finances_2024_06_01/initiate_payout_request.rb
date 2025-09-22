# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module Finances20240601
      # The request schema for the `initiatePayout` operation.
      InitiatePayoutRequest = Structure.new do
        # @return [String] The identifier of the Amazon marketplace. This API supports the following marketplaces: DE,
        # FR, IT, ES, SE, NL, PL, and BE. For a list of possible marketplace IDs, refer to [Marketplace
        # IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [String] The account type in the selected marketplace for which a payout must be initiated. For
        # supported EU marketplaces, the only account type is `Standard Orders`.
        attribute(:account_type, String, from: "accountType")
      end
    end
  end
end
