# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module Finances20240619
      # Metadata describing the seller.
      SellingPartnerMetadata = Structure.new do
        # @return [String] Unique seller identifier.
        attribute?(:selling_partner_id, String, from: "sellingPartnerId")

        # @return [String] Account type of transaction.
        attribute?(:account_type, String, from: "accountType")

        # @return [String] The identifier of the marketplace where the transaction occurred. The marketplace ID is the
        # globally unique identifier of a marketplace. To find the ID for your marketplace, refer to [Marketplace
        # IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
        attribute?(:marketplace_id, String, from: "marketplaceId")
      end
    end
  end
end
