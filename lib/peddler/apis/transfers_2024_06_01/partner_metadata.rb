# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Transfers20240601
      # Metadata that describes the selling partner.
      PartnerMetadata = Structure.new do
        # @return [String] The type of the selling partner's account in the payout.
        attribute(:account_type, String, null: false, from: "accountType")

        # @return [String] The identifier of the marketplace associated with the payout. The marketplace ID is the
        #   globally unique identifier of a marketplace. To find the ID for your marketplace, refer to [Marketplace
        #   IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # @return [String] A unique selling partner identifier.
        attribute(:partner_id, String, null: false, from: "partnerId")
      end
    end
  end
end
