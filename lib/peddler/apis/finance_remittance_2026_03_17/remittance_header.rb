# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class FinanceRemittance20260317
      # Summary information for a remittance payment.
      RemittanceHeader = Structure.new do
        # @return [Money] The payment amount.
        attribute(:payment_amount, Money, null: false, from: "paymentAmount")

        # @return [Time] The date of the payment in ISO 8601 date-time format.
        attribute(:payment_date, Time, null: false, from: "paymentDate")

        # @return [String] The status of the remittance.
        attribute(:remittance_status, String, null: false, from: "remittanceStatus")

        # @return [String] The unique internal identifier for the payment record in the remittance system.
        attribute(:unique_payment_id, String, null: false, from: "uniquePaymentId")

        # @return [String] The country code associated with the remittance in ISO 3166-1 alpha-2 format.
        attribute?(:country_code, String, from: "countryCode")

        # @return [Float] The exchange rate applied to the payment.
        attribute?(:exchange_rate, Float, from: "exchangeRate")

        # @return [Integer] The number of line items in the remittance.
        attribute?(:line_item_count, Integer, from: "lineItemCount")

        # @return [Money] The payment amount in the invoice currency. Use this value when the invoice currency differs
        #   from the payment currency.
        attribute?(:payment_amount_in_invoice_currency, Money, from: "paymentAmountInInvoiceCurrency")

        # @return [String] The method used for the payment.
        attribute?(:payment_method, String, from: "paymentMethod")

        # @return [String] The external payment reference number associated with the remittance. Vendors can use this
        #   identifier to search for payment information.
        attribute?(:payment_number, String, from: "paymentNumber")

        # @return [Array<RelatedIdentifier>] A list of related business identifiers for the remittance.
        attribute?(:related_identifiers, [RelatedIdentifier], from: "relatedIdentifiers")
      end
    end
  end
end
