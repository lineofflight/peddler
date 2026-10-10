# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module Finances20240619
      # Metadata that describes the seller.
      SellingPartnerMetadata = Structure.new do
        # The type of account in the transaction.
        attribute?(:account_type, String, from: "accountType")

        # The identifier of the marketplace where the transaction occurred. The marketplace ID is the globally unique
        # identifier of a marketplace. To find the ID for a marketplace, refer to [Marketplace
        # IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
        attribute?(:marketplace_id, String, from: "marketplaceId")

        # The unique seller identifier.
        attribute?(:selling_partner_id, String, from: "sellingPartnerId")
      end
    end
  end
end
