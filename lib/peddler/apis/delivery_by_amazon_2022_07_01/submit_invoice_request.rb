# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module DeliveryByAmazon20220701
      # The request schema for the `submitInvoice` operation.
      SubmitInvoiceRequest = Structure.new do
        # MD5 sum for validating the invoice data. For more information about calculating this value, see [Working with
        # Content-MD5 Checksums](https://docs.developer.amazonservices.com/en_US/dev_guide/DG_MD5.html).
        attribute(:content_md5_value, String, null: false, from: "contentMD5Value")

        # The binary object representing an invoice's content.
        attribute(:invoice_content, String, null: false, from: "invoiceContent")

        # The type of an invoice.
        attribute(:invoice_type, String, null: false, from: "invoiceType")

        # An Amazon store identifier.
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # The Amazon program that the seller is currently enrolled.
        attribute(:program_type, String, null: false, from: "programType")
      end
    end
  end
end
