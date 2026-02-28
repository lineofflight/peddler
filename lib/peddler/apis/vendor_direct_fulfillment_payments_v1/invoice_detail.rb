# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class VendorDirectFulfillmentPaymentsV1
      # Represents the details of an invoice, including invoice number, date, parties involved, payment terms, totals,
      # taxes, charges, and line items.
      InvoiceDetail = Structure.new do
        # @return [Time] Invoice date.
        attribute(:invoice_date, Time, null: false, from: "invoiceDate")

        # @return [String] The unique invoice number.
        attribute(:invoice_number, String, null: false, from: "invoiceNumber")

        # @return [Money] Total amount details of the invoice.
        attribute(:invoice_total, Money, null: false, from: "invoiceTotal")

        # @return [Array<InvoiceItem>] Provides the details of the items in this invoice.
        attribute(:items, [InvoiceItem], null: false)

        # @return [PartyIdentification] Name, address and tax details of the party receiving the payment of this
        #   invoice.
        attribute(:remit_to_party, PartyIdentification, null: false, from: "remitToParty")

        # @return [PartyIdentification] Warehouse code of the vendor as in the order.
        attribute(:ship_from_party, PartyIdentification, null: false, from: "shipFromParty")

        # @return [Array<AdditionalDetails>] Additional details provided by the selling party, for tax-related or other
        #   purposes.
        attribute?(:additional_details, [AdditionalDetails], from: "additionalDetails")

        # @return [PartyIdentification] Name, address and tax details of the party to whom this invoice is issued.
        attribute?(:bill_to_party, PartyIdentification, from: "billToParty")

        # @return [Array<ChargeDetails>] Total charge amount details for all line items.
        attribute?(:charge_details, [ChargeDetails], from: "chargeDetails")

        # @return [String] The payment terms for the invoice.
        attribute?(:payment_terms_code, String, from: "paymentTermsCode")

        # @return [String] An additional unique reference number used for regulatory or other purposes.
        attribute?(:reference_number, String, from: "referenceNumber")

        # @return [String] Ship-to country code.
        attribute?(:ship_to_country_code, String, from: "shipToCountryCode")

        # @return [Array<TaxDetail>] Individual tax details per line item.
        attribute?(:tax_totals, [TaxDetail], from: "taxTotals")
      end
    end
  end
end
