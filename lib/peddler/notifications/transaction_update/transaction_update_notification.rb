# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module TransactionUpdate
      # Nested notification data
      TransactionUpdateNotification = Structure.new do
        # @return [String] The date and time when the transaction was posted.
        attribute(:posted_date, String, null: false, from: "PostedDate")

        # @return [SellingPartnerMetadata]
        attribute(:selling_partner_metadata, SellingPartnerMetadata, null: false, from: "SellingPartnerMetadata")

        # @return [TotalAmount]
        attribute(:total_amount, TotalAmount, null: false, from: "TotalAmount")

        # @return [String] Type of transaction.
        attribute(:transaction_type, String, null: false, from: "TransactionType")

        # @return [Array<RelatedIdentifier>] Related business identifiers of the transaction.
        attribute?(:related_identifiers, [RelatedIdentifier], from: "RelatedIdentifiers")
      end
    end
  end
end
