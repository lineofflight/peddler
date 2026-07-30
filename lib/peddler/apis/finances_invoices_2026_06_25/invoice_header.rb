# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class FinancesInvoices20260625
      # Represents the header-level information for an invoice, including parties involved (payer/payee), financial
      # amounts, status, dates, and related business identifiers.
      InvoiceHeader = Structure.new do
        # @return [Time] When the invoice was created. In ISO 8601 format.
        attribute(:creation_date, Time, null: false, from: "creationDate")

        # @return [Money] The total monetary amount of the invoice.
        attribute(:invoice_amount, Money, null: false, from: "invoiceAmount")

        # @return [String] The unique identifier for an invoice. For AP-Inventory invoices, this is formatted as
        #   `InvoiceNumber~PayeeCode`. This field can be used as an input to the `getInvoice` operation to fetch invoice
        #   details.
        attribute(:invoice_identifier, String, null: false, from: "invoiceIdentifier")

        # @return [String] The invoice number provided when the invoice was created.
        attribute(:invoice_number, String, null: false, from: "invoiceNumber")

        # @return [String] The current state of the invoice.
        attribute(:invoice_status, String, null: false, from: "invoiceStatus")

        # @return [String] The type of invoice.
        attribute(:invoice_type, String, null: false, from: "invoiceType")

        # @return [Time] When the invoice was issued. In ISO 8601 format.
        attribute(:issue_date, Time, null: false, from: "issueDate")

        # @return [Time] When the invoice was last updated. In ISO 8601 format.
        attribute(:last_updated_date, Time, null: false, from: "lastUpdatedDate")

        # @return [PartnerMetadata] The payee-related information.
        attribute(:payee, PartnerMetadata, null: false)

        # @return [PartnerMetadata] The payer-related information.
        attribute(:payer, PartnerMetadata, null: false)

        # @return [BillingPeriod] The billing period for an invoice.
        attribute?(:billing_period, BillingPeriod, from: "billingPeriod")

        # @return [Time] The due date of the invoice. In ISO 8601 format.
        attribute?(:due_date, Time, from: "dueDate")

        # @return [Array<Breakdown>] The breakdown of the invoice amount into sub-components.
        #
        # **Possible `breakdownType` values:**
        #
        # * `Total`: Total invoice amount.
        # * `InvoiceAmountWithoutTax`: Invoice amount excluding tax.
        # * `TaxAmount`: Tax amount on the invoice.
        # * `MiscCharges`: Miscellaneous charges on the invoice.
        # * `Other`: Other breakdown type.
        attribute?(:invoice_amount_breakdowns, [Breakdown], from: "invoiceAmountBreakdowns")

        # @return [Array<Breakdown>] The breakdown of the invoice settlement amount into sub-components.
        #
        # **Possible `breakdownType` values:**
        #
        # * `AmountPaid`: Amount that has been paid.
        # * `QueuedForPayment`: Amount queued for payment.
        # * `QuickPayDiscount`: Quick pay discount amount.
        # * `QuantityVarianceAmount`: Quantity variance amount.
        # * `PriceVariance`: Price variance amount.
        # * `Other`: Other settlement breakdown type.
        attribute?(:invoice_settlement_breakdowns, [Breakdown], from: "invoiceSettlementBreakdowns")

        # @return [String] Payment terms associated with the invoice.
        attribute?(:payment_terms, String, from: "paymentTerms")

        # @return [Array<RelatedIdentifier>] A list of related business identifiers associated with the invoice.
        attribute?(:related_identifiers, [RelatedIdentifier], from: "relatedIdentifiers")
      end
    end
  end
end
