# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module Orders20260101
      # Information about the customer who purchased the order.
      Buyer = Structure.new do
        # The name of the company or organization for a business order.
        attribute?(:buyer_company_name, String, from: "buyerCompanyName")

        # The anonymized email address of the buyer. **Note:** Only available for merchant-fulfilled (FBM) orders.
        attribute?(:buyer_email, String, from: "buyerEmail")

        # The full name of the customer who placed the order.
        attribute?(:buyer_name, String, from: "buyerName")

        # The purchase order (PO) number entered by the buyer at checkout. Only returned for orders where the buyer
        # entered a PO number at checkout.
        attribute?(:buyer_purchase_order_number, String, from: "buyerPurchaseOrderNumber")
      end
    end
  end
end
