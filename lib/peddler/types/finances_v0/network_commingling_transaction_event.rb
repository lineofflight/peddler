# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/finances_v0/currency"

module Peddler
  module Types
    module FinancesV0
      # A network commingling transaction event.
      NetworkComminglingTransactionEvent = Structure.new do
        # @return [String] The type of network item swap.
        #
        # Possible values:
        #
        # * NetCo - A Fulfillment by Amazon inventory pooling transaction. Available only in the India marketplace.
        #
        # * ComminglingVAT - A commingling VAT transaction. Available only in the UK, Spain, France, Germany, and Italy
        # marketplaces.
        attribute(:transaction_type, String, from: "TransactionType")

        # @return [String] The date and time when the financial event was posted.
        attribute(:posted_date, String, from: "PostedDate")

        # @return [String] The identifier for the network item swap.
        attribute(:net_co_transaction_id, String, from: "NetCoTransactionID")

        # @return [String] The reason for the network item swap.
        attribute(:swap_reason, String, from: "SwapReason")

        # @return [String] The Amazon Standard Identification Number (ASIN) of the swapped item.
        attribute(:asin, String, from: "ASIN")

        # @return [String] The marketplace in which the event took place.
        attribute(:marketplace_id, String, from: "MarketplaceId")

        # @return [Currency] The price of the swapped item minus TaxAmount.
        attribute(:tax_exclusive_amount, Currency, from: "TaxExclusiveAmount")

        # @return [Currency] The tax on the network item swap paid by the seller.
        attribute(:tax_amount, Currency, from: "TaxAmount")
      end
    end
  end
end
