# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module Finances20240619
      # All the information related to a transaction.
      Transaction = Structure.new do
        # A list of breakdowns that detail how the total amount is calculated for the transaction.
        attribute?(:breakdowns, [Breakdown])

        # Additional Information about the transaction.
        attribute?(:contexts, [Context])

        # Describes the reasons for the transaction.
        #
        # **Example:** `Order Payment`, `Refund Order`
        attribute?(:description, String)

        # Additional information about the items in the transaction.
        attribute?(:items, [Item])

        # Information about the marketplace where the transaction occurred.
        attribute?(:marketplace_details, MarketplaceDetails, from: "marketplaceDetails")

        # The date and time when the transaction was posted.
        attribute?(:posted_date, String, from: "postedDate")

        # Identifiers related to the transaction, such as order and shipment IDs.
        attribute?(:related_identifiers, [RelatedIdentifier], from: "relatedIdentifiers")

        # Metadata that describes the seller.
        attribute?(:selling_partner_metadata, SellingPartnerMetadata, from: "sellingPartnerMetadata")

        # The total amount of money in the transaction.
        attribute?(:total_amount, Money, from: "totalAmount")

        # The unique identifier of the transaction.
        attribute?(:transaction_id, String, from: "transactionId")

        # The status of the transaction.
        #
        # **Possible values:**
        #
        # * `DEFERRED`: the transaction is currently deferred.
        # * `RELEASED`: the transaction is currently released.
        # * `DEFERRED_RELEASED`: the transaction was deferred in the past, but is now released. The status of a deferred
        # transaction is updated to `DEFERRED_RELEASED` when the transaction is released.
        attribute?(:transaction_status, String, from: "transactionStatus")

        # The type of transaction.
        #
        # **Possible value:** `Shipment`
        attribute?(:transaction_type, String, from: "transactionType")
      end
    end
  end
end
