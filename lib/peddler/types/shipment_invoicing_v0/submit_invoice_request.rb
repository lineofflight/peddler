# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module ShipmentInvoicingV0
      # The request schema for the submitInvoice operation.
      SubmitInvoiceRequest = Structure.new do
        # @return [String]
        attribute(:invoice_content, String, from: "InvoiceContent")

        # @return [String] An Amazon marketplace identifier.
        attribute(:marketplace_id, String, from: "MarketplaceId")

        # @return [String] MD5 sum for validating the invoice data. For more information about calculating this value,
        # see [Working with Content-MD5
        # Checksums](https://docs.developer.amazonservices.com/en_US/dev_guide/DG_MD5.html).
        attribute(:content_md5_value, String, from: "ContentMD5Value")
      end
    end
  end
end
