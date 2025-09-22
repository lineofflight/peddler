# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/finances_2024_06_19/selling_partner_metadata"
require "peddler/types/finances_2024_06_19/related_identifier"
require "peddler/types/finances_2024_06_19/currency"
require "peddler/types/finances_2024_06_19/marketplace_details"
require "peddler/types/finances_2024_06_19/item"
require "peddler/types/finances_2024_06_19/context"
require "peddler/types/finances_2024_06_19/breakdown"

module Peddler
  module Types
    module Finances20240619
      # Contains all information related to the transaction.
      Transaction = Structure.new do
        # @return [SellingPartnerMetadata] Metadata describing the seller.
        attribute(:selling_partner_metadata, SellingPartnerMetadata, from: "sellingPartnerMetadata")

        # @return [Array<RelatedIdentifier>] Related business identifiers of the transaction.
        attribute(:related_identifiers, [RelatedIdentifier], from: "relatedIdentifiers")

        # @return [String] The type of transaction.
        #
        # Possible values:
        #
        # * Shipment
        attribute(:transaction_type, String, from: "transactionType")

        # @return [String] The unique identifier for the transaction.
        attribute(:transaction_id, String, from: "transactionId")

        # @return [String] The status of the transaction.
        #
        # **Possible values:**
        #
        # * `DEFERRED`: the transaction is currently deferred.
        # * `RELEASED`: the transaction is currently released.
        # * `DEFERRED_RELEASED`: the transaction was deferred in the past, but is now released. The status of a deferred
        # transaction is updated to `DEFERRED_RELEASED` when the transaction is released.
        attribute(:transaction_status, String, from: "transactionStatus")

        # @return [String] Describes the reasons for the transaction.
        #
        # Example: 'Order Payment','Refund Order'
        attribute(:description, String)

        # @return [String] The date and time when the transaction was posted.
        attribute(:posted_date, String, from: "postedDate")

        # @return [Currency] Total amount of transaction.
        attribute(:total_amount, Currency, from: "totalAmount")

        # @return [MarketplaceDetails] Information about the marketplace where the transaction occurred.
        attribute(:marketplace_details, MarketplaceDetails, from: "marketplaceDetails")

        # @return [Array<Item>] Additional information about the items in Transaction.
        attribute(:items, [Item])

        # @return [Array<Context>] Additional Information about the transaction.
        attribute(:contexts, [Context])

        # @return [Array<Breakdown>] A list of breakdowns that detail how the total amount is calculated for the
        # transaction.
        attribute(:breakdowns, [Breakdown])
      end
    end
  end
end
