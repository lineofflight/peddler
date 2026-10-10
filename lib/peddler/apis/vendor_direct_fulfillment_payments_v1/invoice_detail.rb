# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module VendorDirectFulfillmentPaymentsV1
      # Represents the details of an invoice, including invoice number, date, parties involved, payment terms, totals,
      # taxes, charges, and line items.
      InvoiceDetail = Structure.new do
        # Invoice date.
        attribute(:invoice_date, Time, null: false, from: "invoiceDate")

        # The unique invoice number.
        attribute(:invoice_number, String, null: false, from: "invoiceNumber")

        # Total amount details of the invoice.
        attribute(:invoice_total, Money, null: false, from: "invoiceTotal")

        # Provides the details of the items in this invoice.
        attribute(:items, [InvoiceItem], null: false)

        # Name, address and tax details of the party receiving the payment of this invoice.
        attribute(:remit_to_party, PartyIdentification, null: false, from: "remitToParty")

        # Warehouse code of the vendor as in the order.
        attribute(:ship_from_party, PartyIdentification, null: false, from: "shipFromParty")

        # Additional details provided by the selling party, for tax-related or other purposes.
        attribute?(:additional_details, [AdditionalDetails], from: "additionalDetails")

        # Total allowance amount details for all line items.
        attribute?(:allowance_details, [AllowanceDetails], from: "allowanceDetails")

        # Name, address and tax details of the party that issues this invoice.
        attribute?(:bill_from_party, PartyIdentification, from: "billFromParty")

        # Name, address and tax details of the party to whom this invoice is issued.
        attribute?(:bill_to_party, PartyIdentification, from: "billToParty")

        # Total charge amount details for all line items.
        attribute?(:charge_details, [ChargeDetails], from: "chargeDetails")

        # Date of delivery of the goods or completion of the service.
        attribute?(:delivery_date, Time, from: "deliveryDate")

        # Currency exchange rate applied on the invoice, where amounts are shown in a foreign currency.
        attribute?(:exchange_rate, String, from: "exchangeRate")

        # Sum of all invoice line net amounts, excluding tax, charges and allowances. Provided for EU e-invoice
        # interoperability.
        attribute?(:invoice_base_amount, Money, from: "invoiceBaseAmount")

        # The payment terms for the invoice.
        attribute?(:payment_terms_code, String, from: "paymentTermsCode")

        # An additional unique reference number used for regulatory or other purposes.
        attribute?(:reference_number, String, from: "referenceNumber")

        # Ship-to country code.
        attribute?(:ship_to_country_code, String, from: "shipToCountryCode")

        # Name, address and tax details of the party receiving a shipment of products. Provided when the full ship-to
        # address is required in addition to shipToCountryCode.
        attribute?(:ship_to_party, PartyIdentification, from: "shipToParty")

        # The date on which the tax becomes chargeable, if different from the invoice date. When absent, the invoice
        # date applies.
        attribute?(:tax_point_date, Time, from: "taxPointDate")

        # Name, address and tax registration details of the supplier's fiscal or tax representative, where one is
        # required.
        attribute?(:tax_representative_party, PartyIdentification, from: "taxRepresentativeParty")

        # Individual tax details per line item.
        attribute?(:tax_totals, [TaxDetail], from: "taxTotals")

        # Name, address and tax registration details of the VAT group representative member, when the supplier reports
        # VAT as part of a VAT group.
        attribute?(:vat_group_party, PartyIdentification, from: "vatGroupParty")
      end
    end
  end
end
