# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FinancesV0
      # All the information related to the transaction.
      Transaction = Structure.new do
        # @return [String] The date and time when the transaction was posted.
        attribute?(:posted_date, String, from: "PostedDate")

        # @return [Array<RelatedIdentifier>] Related business identifiers of the transaction.
        attribute?(:related_identifiers, [RelatedIdentifier], from: "RelatedIdentifiers")

        # @return [SellingPartnerMetadata] Metadata describing the seller.
        attribute?(:selling_partner_metadata, SellingPartnerMetadata, from: "SellingPartnerMetadata")

        # @return [Money] The total amount of money in the transaction.
        attribute?(:total_amount, Money, from: "TotalAmount")

        # @return [String] The type of transaction.
        #
        # Possible values:
        #
        # * `Shipment`
        attribute?(:transaction_type, String, from: "TransactionType")
      end
    end
  end
end
