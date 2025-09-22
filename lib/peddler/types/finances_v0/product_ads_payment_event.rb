# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/finances_v0/currency"

module Peddler
  module Types
    module FinancesV0
      # A Sponsored Products payment event.
      ProductAdsPaymentEvent = Structure.new do
        # @return [String] The date and time when the financial event was posted.
        attribute(:posted_date, String, from: "postedDate")

        # @return [String] Indicates if the transaction is for a charge or a refund.
        #
        # Possible values:
        #
        # * charge - Charge
        #
        # * refund - Refund
        attribute(:transaction_type, String, from: "transactionType")

        # @return [String] Identifier for the invoice that the transaction appears in.
        attribute(:invoice_id, String, from: "invoiceId")

        # @return [Currency] Base amount of the transaction, before tax.
        attribute(:base_value, Currency, from: "baseValue")

        # @return [Currency] Tax amount of the transaction.
        attribute(:tax_value, Currency, from: "taxValue")

        # @return [Currency] The total amount of the transaction. Equal to baseValue + taxValue.
        attribute(:transaction_value, Currency, from: "transactionValue")
      end
    end
  end
end
