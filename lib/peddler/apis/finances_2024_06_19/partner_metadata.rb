# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Finances20240619
      # Metadata that describes the seller.
      PartnerMetadata = Structure.new do
        # @return [String] The type of account.
        attribute?(:account_type, String, from: "accountType")

        # @return [String] The identifier of the marketplace where the transaction occurred. The marketplace ID is the
        #   globally unique identifier of a marketplace. To find the ID for a marketplace, refer to [Marketplace
        #   IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
        attribute?(:marketplace_id, String, from: "marketplaceId")

        # @return [String] The unique seller identifier.
        attribute?(:partner_id, String, from: "partnerId")
      end
    end
  end
end
