# frozen_string_literal: true

require "peddler/types/money"
require "peddler/types/vendor_invoices_v1/party_identification"
require "peddler/types/vendor_invoices_v1/payment_terms"
require "peddler/types/vendor_invoices_v1/tax_details"
require "peddler/types/vendor_invoices_v1/additional_details"
require "peddler/types/vendor_invoices_v1/charge_details"
require "peddler/types/vendor_invoices_v1/allowance_details"
require "peddler/types/vendor_invoices_v1/invoice_item"

module Peddler
  module Types
    module VendorInvoicesV1
      # Represents an invoice or credit note document with details about the transaction, parties involved, and line
      # items.
      Invoice = Structure.new do
        # @return [String] Identifies the type of invoice.
        attribute(:invoice_type, String, from: "invoiceType")

        # @return [String] Unique number relating to the charges defined in this document. This will be invoice number
        # if the document type is Invoice or CreditNote number if the document type is Credit Note. Failure to provide
        # this reference will result in a rejection.
        attribute(:id, String)

        # @return [String] An additional unique reference number used for regulatory or other purposes.
        attribute(:reference_number, String, from: "referenceNumber")

        # @return [String] Date when the invoice/credit note information was generated in the origin's accounting
        # system. The invoice date should be on or after the purchase order creation date.
        attribute(:date, String)

        # @return [PartyIdentification] Name, address and tax details of the party receiving the payment of this
        # invoice.
        attribute(:remit_to_party, PartyIdentification, from: "remitToParty")

        # @return [PartyIdentification] Name, address and tax details of the party receiving a shipment of products.
        attribute(:ship_to_party, PartyIdentification, from: "shipToParty")

        # @return [PartyIdentification] Name, address and tax details of the party sending a shipment of products.
        attribute(:ship_from_party, PartyIdentification, from: "shipFromParty")

        # @return [PartyIdentification] Name, address and tax details of the party to whom this invoice is issued.
        attribute(:bill_to_party, PartyIdentification, from: "billToParty")

        # @return [PaymentTerms] The payment terms for the invoice.
        attribute(:payment_terms, PaymentTerms, from: "paymentTerms")

        # @return [Types::Money] Total monetary amount charged in the invoice or full value of credit note to be paid
        # including all relevant taxes. It is the total amount of invoice (including charges, less allowances) before
        # terms discount (if discount is applicable).
        attribute(:invoice_total, Types::Money, from: "invoiceTotal")

        # @return [Array<TaxDetails>] Total tax amount details for all line items.
        attribute(:tax_details, [TaxDetails], from: "taxDetails")

        # @return [Array<AdditionalDetails>] Additional details provided by the selling party, for tax related or other
        # purposes.
        attribute(:additional_details, [AdditionalDetails], from: "additionalDetails")

        # @return [Array<ChargeDetails>] Total charge amount details for all line items.
        attribute(:charge_details, [ChargeDetails], from: "chargeDetails")

        # @return [Array<AllowanceDetails>] Total allowance amount details for all line items.
        attribute(:allowance_details, [AllowanceDetails], from: "allowanceDetails")

        # @return [Array<InvoiceItem>] The list of invoice items.
        attribute(:items, [InvoiceItem])
      end
    end
  end
end
