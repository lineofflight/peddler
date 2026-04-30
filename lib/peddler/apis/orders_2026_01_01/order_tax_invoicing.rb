# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Orders20260101
      # Tax invoicing information for the order.
      OrderTaxInvoicing = Structure.new do
        # @return [String] The buyer's invoicing preference, which indicates whether the seller should issue an
        #   individual or a business invoice to the buyer.
        #
        # **Note**: This attribute is only available in the Turkey marketplace.
        #
        # **Possible values**:
        # - `INDIVIDUAL` (Issues an individual invoice to the buyer) - `BUSINESS` (Issues a business invoice to the
        #   buyer)
        attribute?(:buyer_invoice_preference, String, from: "buyerInvoicePreference")

        # @return [String] The status of the invoice. Only available for Easy Ship orders and orders in the Brazil
        #   marketplace.
        #
        # **Possible values**:
        # - `NOT_REQUIRED` (The order does not require an electronic invoice to be uploaded) - `NOT_FOUND` (The order
        #   requires an electronic invoice but it is not uploaded) - `PROCESSING` (The required electronic invoice was
        #   uploaded and is processing) - `ERRORED` (The uploaded electronic invoice was not accepted) - `ACCEPTED` (The
        #   uploaded electronic invoice was accepted)
        attribute?(:invoice_status, String, from: "invoiceStatus")
      end
    end
  end
end
