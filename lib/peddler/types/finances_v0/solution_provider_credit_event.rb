# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/money"
require "structure"

module Peddler
  module Types
    module FinancesV0
      # A credit given to a solution provider.
      SolutionProviderCreditEvent = Structure.new do
        # @return [String] The two-letter country code of the country associated with the marketplace where the order
        # was placed.
        attribute?(:marketplace_country_code, String, from: "MarketplaceCountryCode")

        # @return [String] The identifier of the marketplace where the order was placed.
        attribute?(:marketplace_id, String, from: "MarketplaceId")

        # @return [String] The Amazon-defined identifier of the solution provider.
        attribute?(:provider_id, String, from: "ProviderId")

        # @return [String] The store name where the payment event occurred.
        attribute?(:provider_store_name, String, from: "ProviderStoreName")

        # @return [String] The transaction type.
        attribute?(:provider_transaction_type, String, from: "ProviderTransactionType")

        # @return [String] The Amazon-defined identifier of the seller.
        attribute?(:seller_id, String, from: "SellerId")

        # @return [String] A seller-defined identifier for an order.
        attribute?(:seller_order_id, String, from: "SellerOrderId")

        # @return [String] The store name where the payment event occurred.
        attribute?(:seller_store_name, String, from: "SellerStoreName")

        # @return [Money] The amount of the credit.
        attribute?(:transaction_amount, Money, from: "TransactionAmount")

        # @return [String] The date and time that the credit transaction was created, in [ISO
        # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date time format.
        attribute?(:transaction_creation_date, String, from: "TransactionCreationDate")
      end
    end
  end
end
