# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Finances20240619
      # All the information related to a transaction.
      Transaction = Structure.new do
        # @return [Array<Breakdown>] A list of breakdowns that detail how the total amount is calculated for the
        #   transaction.
        attribute?(:breakdowns, [Breakdown])

        # @return [Array<Context>] Additional Information about the transaction.
        attribute?(:contexts, [Context])

        # @return [String] Describes the reasons for the transaction.
        #
        # **Example:** 'Order Payment', 'Refund Order'
        attribute?(:description, String)

        # @return [Array<Item>] Additional information about the items in the transaction.
        attribute?(:items, [Item])

        # @return [MarketplaceDetails] Information about the marketplace where the transaction occurred.
        attribute?(:marketplace_details, MarketplaceDetails, from: "marketplaceDetails")

        # @return [String] The date and time when the transaction was posted.
        attribute?(:posted_date, String, from: "postedDate")

        # @return [Array<RelatedIdentifier>] Identifiers related to the transaction, such as order and shipment IDs.
        attribute?(:related_identifiers, [RelatedIdentifier], from: "relatedIdentifiers")

        # @return [SellingPartnerMetadata] Metadata that describes the seller.
        attribute?(:selling_partner_metadata, SellingPartnerMetadata, from: "sellingPartnerMetadata")

        # @return [Money] The total amount of money in the transaction.
        attribute?(:total_amount, Money, from: "totalAmount")

        # @return [String] The unique identifier of the transaction.
        attribute?(:transaction_id, String, from: "transactionId")

        # @return [String] The status of the transaction.
        #
        # **Possible values:**
        #
        # * `DEFERRED`: the transaction is currently deferred.
        # * `RELEASED`: the transaction is currently released.
        # * `DEFERRED_RELEASED`: the transaction was deferred in the past, but is now released. The status of a deferred
        #   transaction is updated to `DEFERRED_RELEASED` when the transaction is released.
        attribute?(:transaction_status, String, from: "transactionStatus")

        # @return [String] The type of transaction.
        #
        # **Possible value:** `Shipment`
        attribute?(:transaction_type, String, from: "transactionType")
      end
    end
  end
end
