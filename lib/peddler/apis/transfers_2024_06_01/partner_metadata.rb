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

        # @return [String] The identifier of the store associated with the payout. To find the ID for your store, refer
        #   to [Store Identifiers](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # @return [String] A unique selling partner identifier.
        attribute(:partner_id, String, null: false, from: "partnerId")
      end
    end
  end
end
