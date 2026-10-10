# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FinancesV0
      # A Sponsored Products payment event.
      ProductAdsPaymentEvent = Structure.new do
        # Base amount of the transaction, before tax.
        attribute?(:base_value, Money, from: "baseValue")

        # The identifier for the invoice that includes the transaction.
        attribute?(:invoice_id, String, from: "invoiceId")

        # The date and time when the financial event was posted.
        attribute?(:posted_date, String, from: "postedDate")

        # Tax amount of the transaction.
        attribute?(:tax_value, Money, from: "taxValue")

        # Indicates if the transaction is for a charge or a refund.
        #
        # Possible values:
        #
        # * `charge`
        #
        # * `refund`
        attribute?(:transaction_type, String, from: "transactionType")

        # The total amount of the transaction. Equal to `baseValue` + `taxValue`.
        attribute?(:transaction_value, Money, from: "transactionValue")
      end
    end
  end
end
