# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module TransactionUpdate
      # Metadata describing the seller.
      SellingPartnerMetadata = Structure.new do
        # Account type of transaction.
        attribute(:account_type, String, null: false, from: "AccountType")

        # Marketplace identifier of transaction.
        attribute(:marketplace_id, String, null: false, from: "MarketplaceId")

        # Unique seller identifier.
        attribute(:selling_partner_id, String, null: false, from: "SellingPartnerId")
      end
    end
  end
end
