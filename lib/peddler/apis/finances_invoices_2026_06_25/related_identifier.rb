# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FinancesInvoices20260625
      # Related business identifier of the transaction.
      RelatedIdentifier = Structure.new do
        # The name of the related identifier. Known values: `PAYEE_CODE`, `PURCHASE_ORDER_IDS`, `SHORTAGE_INVOICE_IDS`,
        # `ASN_IDS`, `RETURN_IDS`, `AGREEMENT_IDS`, `PRODUCT_LINE`, `VENDOR_CODE`, `UNIQUE_PAYMENT_IDS`, `WAREHOUSE_ID`.
        attribute(:related_identifier_name, String, null: false, from: "relatedIdentifierName")

        # The corresponding related identifier values.
        attribute(:related_identifier_value, [String], null: false, from: "relatedIdentifierValue")
      end
    end
  end
end
