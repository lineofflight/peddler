# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FinancesV0
      # A network commingling transaction event.
      NetworkComminglingTransactionEvent = Structure.new do
        # The Amazon Standard Identification Number (ASIN) of the swapped item.
        attribute?(:asin, String, from: "ASIN")

        # The marketplace in which the event took place.
        attribute?(:marketplace_id, String, from: "MarketplaceId")

        # The identifier for the network item swap.
        attribute?(:net_co_transaction_id, String, from: "NetCoTransactionID")

        # The date and time when the financial event was posted.
        attribute?(:posted_date, String, from: "PostedDate")

        # The reason for the network item swap.
        attribute?(:swap_reason, String, from: "SwapReason")

        # The tax on the network item swap paid by the seller.
        attribute?(:tax_amount, Money, from: "TaxAmount")

        # The price of the swapped item minus `TaxAmount`.
        attribute?(:tax_exclusive_amount, Money, from: "TaxExclusiveAmount")

        # The type of network item swap.
        #
        # Possible values:
        #
        # * `NetCo`: A Fulfillment by Amazon inventory pooling transaction. Available only in the India marketplace.
        #
        # * `ComminglingVAT`: A commingling VAT transaction. Available only in the Spain, UK, France, Germany, and Italy
        # marketplaces.
        attribute?(:transaction_type, String, from: "TransactionType")
      end
    end
  end
end
