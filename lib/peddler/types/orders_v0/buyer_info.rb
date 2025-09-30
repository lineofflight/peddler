# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/orders_v0/buyer_tax_info"

module Peddler
  module Types
    module OrdersV0
      # Buyer information.
      BuyerInfo = Structure.new do
        # @return [String] The anonymized email address of the buyer.
        attribute?(:buyer_email, String, from: "BuyerEmail")

        # @return [String] The buyer name or the recipient name.
        attribute?(:buyer_name, String, from: "BuyerName")

        # @return [String] The county of the buyer.
        #
        # **Note**: This attribute is only available in the Brazil marketplace.
        attribute?(:buyer_county, String, from: "BuyerCounty")

        # @return [BuyerTaxInfo] Tax information about the buyer. Sellers could use this data to issue electronic
        # invoices for business orders.
        #
        # **Note**: This attribute is only available for business orders in the Brazil, Mexico and India marketplaces.
        attribute?(:buyer_tax_info, BuyerTaxInfo, from: "BuyerTaxInfo")

        # @return [String] The purchase order (PO) number entered by the buyer at checkout. Only returned for orders
        # where the buyer entered a PO number at checkout.
        attribute?(:purchase_order_number, String, from: "PurchaseOrderNumber")
      end
    end
  end
end
