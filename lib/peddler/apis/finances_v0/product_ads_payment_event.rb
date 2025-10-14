# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FinancesV0
      # A Sponsored Products payment event.
      ProductAdsPaymentEvent = Structure.new do
        # @return [Money] Base amount of the transaction, before tax.
        attribute?(:base_value, Money, from: "baseValue")

        # @return [String] Identifier for the invoice that the transaction appears in.
        attribute?(:invoice_id, String, from: "invoiceId")

        # @return [String] The date and time when the financial event was posted.
        attribute?(:posted_date, String, from: "postedDate")

        # @return [Money] Tax amount of the transaction.
        attribute?(:tax_value, Money, from: "taxValue")

        # @return [String] Indicates if the transaction is for a charge or a refund.
        #
        # Possible values:
        #
        # * charge - Charge
        #
        # * refund - Refund
        attribute?(:transaction_type, String, from: "transactionType")

        # @return [Money] The total amount of the transaction. Equal to baseValue + taxValue.
        attribute?(:transaction_value, Money, from: "transactionValue")
      end
    end
  end
end
