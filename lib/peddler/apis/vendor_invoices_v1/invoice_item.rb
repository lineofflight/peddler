# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module VendorInvoicesV1
      # Details of the item being invoiced.
      InvoiceItem = Structure.new do
        # Invoiced quantity of this item. Quantity must be greater than zero.
        attribute(:invoiced_quantity, ItemQuantity, null: false, from: "invoicedQuantity")

        # Unique number related to this line item.
        attribute(:item_sequence_number, Integer, null: false, from: "itemSequenceNumber")

        # The item cost to Amazon, which should match the cost on the order. Price information should not be zero or
        # negative. It indicates net unit price. Net cost means VAT is not included in cost. If items are priced by
        # weight, this cost need to be considered in conjunction with netCostUnitOfMeasure. E.g.: $5/LB
        attribute(:net_cost, Money, null: false, from: "netCost")

        # Line-level additional details provided by the selling party, e.g. tax exemption reason code and text.
        attribute?(:additional_details, [AdditionalDetails], from: "additionalDetails")

        # Individual allowance details per line item.
        attribute?(:allowance_details, [AllowanceDetails], from: "allowanceDetails")

        # Amazon Standard Identification Number (ASIN) of an item.
        attribute?(:amazon_product_identifier, String, from: "amazonProductIdentifier")

        # Individual charge details per line item.
        attribute?(:charge_details, [ChargeDetails], from: "chargeDetails")

        # Details required in order to process a credit note. This information is required only if invoiceType is
        # CreditNote.
        attribute?(:credit_note_details, CreditNoteDetails, from: "creditNoteDetails")

        # HSN Tax code. The HSN number cannot contain alphabets.
        attribute?(:hsn_code, String, from: "hsnCode")

        # Product or service description for the invoiced line item.
        attribute?(:item_description, String, from: "itemDescription")

        # This field represents weight unit of measure of items that are ordered by cases and supporting priced by
        # weight. Known values: `POUNDS`, `OUNCES`, `GRAMS`, `KILOGRAMS`.
        attribute?(:net_cost_unit_of_measure, String, from: "netCostUnitOfMeasure")

        # The Amazon purchase order number for this invoiced line item. Formatting Notes: 8-character alpha-numeric
        # code. This value is mandatory only when invoiceType is Invoice, and is not required when invoiceType is
        # CreditNote.
        attribute?(:purchase_order_number, String, from: "purchaseOrderNumber")

        # Individual tax details per line item.
        attribute?(:tax_details, [TaxDetails], from: "taxDetails")

        # The vendor selected product identifier of the item. Should be the same as was provided in the purchase order.
        attribute?(:vendor_product_identifier, String, from: "vendorProductIdentifier")
      end
    end
  end
end
