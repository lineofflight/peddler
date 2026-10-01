# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorInvoicesV1
      # Represents an invoice or credit note document with details about the transaction, parties involved, and line
      # items.
      Invoice = Structure.new do
        # @return [String] Date when the invoice/credit note information was generated in the origin's accounting
        #   system. The invoice date should be on or after the purchase order creation date.
        attribute(:date, String, null: false)

        # @return [String] Unique number relating to the charges defined in this document. This will be invoice number
        #   if the document type is Invoice or CreditNote number if the document type is Credit Note. Failure to provide
        #   this reference will result in a rejection.
        attribute(:id, String, null: false)

        # @return [Money] Total monetary amount charged in the invoice or full value of credit note to be paid including
        #   all relevant taxes. It is the total amount of invoice (including charges, less allowances) before terms
        #   discount (if discount is applicable).
        attribute(:invoice_total, Money, null: false, from: "invoiceTotal")

        # @return [String] Identifies the type of invoice.
        attribute(:invoice_type, String, null: false, from: "invoiceType")

        # @return [PartyIdentification] Name, address and tax details of the party receiving the payment of this
        #   invoice.
        attribute(:remit_to_party, PartyIdentification, null: false, from: "remitToParty")

        # @return [Array<AdditionalDetails>] Additional details provided by the selling party, for tax related or other
        #   purposes.
        attribute?(:additional_details, [AdditionalDetails], from: "additionalDetails")

        # @return [Array<AllowanceDetails>] Total allowance amount details for all line items.
        attribute?(:allowance_details, [AllowanceDetails], from: "allowanceDetails")

        # @return [PartyIdentification] Name, address and tax details of the party that issues this invoice.
        attribute?(:bill_from_party, PartyIdentification, from: "billFromParty")

        # @return [PartyIdentification] Name, address and tax details of the party to whom this invoice is issued.
        attribute?(:bill_to_party, PartyIdentification, from: "billToParty")

        # @return [Array<ChargeDetails>] Total charge amount details for all line items.
        attribute?(:charge_details, [ChargeDetails], from: "chargeDetails")

        # @return [Money] Sum of all invoice line net amounts, excluding tax, charges and allowances. Provided for EU
        #   e-invoice interoperability.
        attribute?(:invoice_base_amount, Money, from: "invoiceBaseAmount")

        # @return [Array<InvoiceItem>] The list of invoice items.
        attribute?(:items, [InvoiceItem])

        # @return [PaymentTerms] The payment terms for the invoice.
        attribute?(:payment_terms, PaymentTerms, from: "paymentTerms")

        # @return [String] An additional unique reference number used for regulatory or other purposes.
        attribute?(:reference_number, String, from: "referenceNumber")

        # @return [PartyIdentification] Name, address and tax details of the party sending a shipment of products.
        attribute?(:ship_from_party, PartyIdentification, from: "shipFromParty")

        # @return [PartyIdentification] Name, address and tax details of the party receiving a shipment of products.
        attribute?(:ship_to_party, PartyIdentification, from: "shipToParty")

        # @return [Array<TaxDetails>] Total tax amount details for all line items.
        attribute?(:tax_details, [TaxDetails], from: "taxDetails")

        # @return [String] The date on which the tax becomes chargeable, if different from the invoice date. When
        #   absent, the invoice date applies.
        attribute?(:tax_point_date, String, from: "taxPointDate")

        # @return [PartyIdentification] Name, address and tax registration details of the supplier's fiscal or tax
        #   representative, where one is required. Conditionally mandatory for applicable EU e-invoice scenarios.
        attribute?(:tax_representative_party, PartyIdentification, from: "taxRepresentativeParty")

        # @return [PartyIdentification] Name, address and tax registration details of the VAT group representative
        #   member, when the supplier reports VAT as part of a VAT group. Conditionally mandatory for applicable EU
        #   e-invoice scenarios.
        attribute?(:vat_group_party, PartyIdentification, from: "vatGroupParty")
      end
    end
  end
end
