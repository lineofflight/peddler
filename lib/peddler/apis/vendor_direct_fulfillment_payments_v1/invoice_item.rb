# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorDirectFulfillmentPaymentsV1
      # Provides the details of the items in this invoice.
      InvoiceItem = Structure.new do
        # @return [ItemQuantity] Item quantity invoiced.
        attribute(:invoiced_quantity, ItemQuantity, from: "invoicedQuantity")

        # @return [String] Numbering of the item on the purchase order. The first item will be 1, the second 2, and so
        # on.
        attribute(:item_sequence_number, String, from: "itemSequenceNumber")

        # @return [Money] Net price (before tax) to vendor with currency details.
        attribute(:net_cost, Money, from: "netCost")

        # @return [String] The purchase order number for this order. Formatting Notes: 8-character alpha-numeric code.
        attribute(:purchase_order_number, String, from: "purchaseOrderNumber")

        # @return [String] Buyer's standard identification number (ASIN) of an item.
        attribute?(:buyer_product_identifier, String, from: "buyerProductIdentifier")

        # @return [Array<ChargeDetails>] Individual charge details per line item.
        attribute?(:charge_details, [ChargeDetails], from: "chargeDetails")

        # @return [String] Harmonized System of Nomenclature (HSN) tax code. The HSN number cannot contain alphabets.
        attribute?(:hsn_code, String, from: "hsnCode")

        # @return [Array<TaxDetail>] Individual tax details per line item.
        attribute?(:tax_details, [TaxDetail], from: "taxDetails")

        # @return [String] The vendor's order number for this order.
        attribute?(:vendor_order_number, String, from: "vendorOrderNumber")

        # @return [String] The vendor selected product identification of the item.
        attribute?(:vendor_product_identifier, String, from: "vendorProductIdentifier")
      end
    end
  end
end
