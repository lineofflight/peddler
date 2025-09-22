# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/money"
require "peddler/types/vendor_invoices_v1/item_quantity"
require "peddler/types/vendor_invoices_v1/credit_note_details"
require "peddler/types/vendor_invoices_v1/tax_details"
require "peddler/types/vendor_invoices_v1/charge_details"
require "peddler/types/vendor_invoices_v1/allowance_details"

module Peddler
  module Types
    module VendorInvoicesV1
      # Details of the item being invoiced.
      InvoiceItem = Structure.new do
        # @return [Integer] Unique number related to this line item.
        attribute(:item_sequence_number, Integer, from: "itemSequenceNumber")

        # @return [String] Amazon Standard Identification Number (ASIN) of an item.
        attribute(:amazon_product_identifier, String, from: "amazonProductIdentifier")

        # @return [String] The vendor selected product identifier of the item. Should be the same as was provided in the
        # purchase order.
        attribute(:vendor_product_identifier, String, from: "vendorProductIdentifier")

        # @return [ItemQuantity] Invoiced quantity of this item. Quantity must be greater than zero.
        attribute(:invoiced_quantity, ItemQuantity, from: "invoicedQuantity")

        # @return [Money] The item cost to Amazon, which should match the cost on the order. Price information should
        # not be zero or negative. It indicates net unit price. Net cost means VAT is not included in cost. If items are
        # priced by weight, this cost need to be considered in conjunction with netCostUnitOfMeasure. E.g.: $5/LB
        attribute(:net_cost, Money, from: "netCost")

        # @return [String] This field represents weight unit of measure of items that are ordered by cases and
        # supporting priced by weight.
        attribute(:net_cost_unit_of_measure, String, from: "netCostUnitOfMeasure")

        # @return [String] The Amazon purchase order number for this invoiced line item. Formatting Notes: 8-character
        # alpha-numeric code. This value is mandatory only when invoiceType is Invoice, and is not required when
        # invoiceType is CreditNote.
        attribute(:purchase_order_number, String, from: "purchaseOrderNumber")

        # @return [String] HSN Tax code. The HSN number cannot contain alphabets.
        attribute(:hsn_code, String, from: "hsnCode")

        # @return [CreditNoteDetails] Details required in order to process a credit note. This information is required
        # only if invoiceType is CreditNote.
        attribute(:credit_note_details, CreditNoteDetails, from: "creditNoteDetails")

        # @return [Array<TaxDetails>] Individual tax details per line item.
        attribute(:tax_details, [TaxDetails], from: "taxDetails")

        # @return [Array<ChargeDetails>] Individual charge details per line item.
        attribute(:charge_details, [ChargeDetails], from: "chargeDetails")

        # @return [Array<AllowanceDetails>] Individual allowance details per line item.
        attribute(:allowance_details, [AllowanceDetails], from: "allowanceDetails")
      end
    end
  end
end
