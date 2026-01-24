# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class OrdersV0
      # Buyer information.
      BuyerInfo = Structure.new do
        # @return [String] The county of the buyer.
        #
        # **Note**: This attribute is only available in the Brazil marketplace.
        attribute?(:buyer_county, String, from: "BuyerCounty")

        # @return [String] The buyer name or the recipient name.
        attribute?(:buyer_name, String, from: "BuyerName")

        # @return [BuyerTaxInfo] Tax information about the buyer. Sellers could use this data to issue electronic
        #   invoices for business orders.
        #
        # **Note**: This attribute is only available for business orders in the Brazil, Mexico and India marketplaces.
        attribute?(:buyer_tax_info, BuyerTaxInfo, from: "BuyerTaxInfo")

        # @return [String] The purchase order (PO) number entered by the buyer at checkout. Only returned for orders
        #   where the buyer entered a PO number at checkout.
        attribute?(:purchase_order_number, String, from: "PurchaseOrderNumber")
      end
    end
  end
end
