# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module TransactionUpdate
      # Metadata describing the seller.
      SellingPartnerMetadata = Structure.new do
        # @return [String] Account type of transaction.
        attribute(:account_type, String, from: "AccountType")

        # @return [String] Marketplace identifier of transaction.
        attribute(:marketplace_id, String, from: "MarketplaceId")

        # @return [String] Unique seller identifier.
        attribute(:selling_partner_id, String, from: "SellingPartnerId")
      end
    end
  end
end
