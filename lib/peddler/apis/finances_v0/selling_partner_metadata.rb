# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FinancesV0
      # Metadata describing the seller.
      SellingPartnerMetadata = Structure.new do
        # @return [String] The type of account in the transaction.
        attribute?(:account_type, String, from: "AccountType")

        # @return [String] The identifier of the marketplace in which the transaction occurred.
        attribute?(:marketplace_id, String, from: "MarketplaceId")

        # @return [String] The unique seller identifier.
        attribute?(:selling_partner_id, String, from: "SellingPartnerId")
      end
    end
  end
end
