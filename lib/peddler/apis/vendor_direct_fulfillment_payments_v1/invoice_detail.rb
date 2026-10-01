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

        # @return [Array<AllowanceDetails>] Total allowance amount details for all line items.
        attribute?(:allowance_details, [AllowanceDetails], from: "allowanceDetails")

        # @return [PartyIdentification] Name, address and tax details of the party that issues this invoice.
        attribute?(:bill_from_party, PartyIdentification, from: "billFromParty")

        # @return [PartyIdentification] Name, address and tax details of the party to whom this invoice is issued.
        attribute?(:bill_to_party, PartyIdentification, from: "billToParty")

        # @return [Array<ChargeDetails>] Total charge amount details for all line items.
        attribute?(:charge_details, [ChargeDetails], from: "chargeDetails")

        # @return [Time] Date of delivery of the goods or completion of the service.
        attribute?(:delivery_date, Time, from: "deliveryDate")

        # @return [String] Currency exchange rate applied on the invoice, where amounts are shown in a foreign currency.
        attribute?(:exchange_rate, String, from: "exchangeRate")

        # @return [Money] Sum of all invoice line net amounts, excluding tax, charges and allowances. Provided for EU
        #   e-invoice interoperability.
        attribute?(:invoice_base_amount, Money, from: "invoiceBaseAmount")

        # @return [String] The payment terms for the invoice.
        attribute?(:payment_terms_code, String, from: "paymentTermsCode")

        # @return [String] An additional unique reference number used for regulatory or other purposes.
        attribute?(:reference_number, String, from: "referenceNumber")

        # @return [String] Ship-to country code.
        attribute?(:ship_to_country_code, String, from: "shipToCountryCode")

        # @return [PartyIdentification] Name, address and tax details of the party receiving a shipment of products.
        #   Provided when the full ship-to address is required in addition to shipToCountryCode.
        attribute?(:ship_to_party, PartyIdentification, from: "shipToParty")

        # @return [Time] The date on which the tax becomes chargeable, if different from the invoice date. When absent,
        #   the invoice date applies.
        attribute?(:tax_point_date, Time, from: "taxPointDate")

        # @return [PartyIdentification] Name, address and tax registration details of the supplier's fiscal or tax
        #   representative, where one is required.
        attribute?(:tax_representative_party, PartyIdentification, from: "taxRepresentativeParty")

        # @return [Array<TaxDetail>] Individual tax details per line item.
        attribute?(:tax_totals, [TaxDetail], from: "taxTotals")

        # @return [PartyIdentification] Name, address and tax registration details of the VAT group representative
        #   member, when the supplier reports VAT as part of a VAT group.
        attribute?(:vat_group_party, PartyIdentification, from: "vatGroupParty")
      end
    end
  end
end
