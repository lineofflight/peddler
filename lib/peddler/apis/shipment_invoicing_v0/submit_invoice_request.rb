# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShipmentInvoicingV0
      # The request schema for the submitInvoice operation.
      SubmitInvoiceRequest = Structure.new do
        # @return [String] MD5 sum for validating the invoice data. For more information about calculating this value,
        #   see [Working with Content-MD5
        #   Checksums](https://docs.developer.amazonservices.com/en_US/dev_guide/DG_MD5.html).
        attribute(:content_md5_value, String, from: "ContentMD5Value")

        # @return [String]
        attribute(:invoice_content, String, from: "InvoiceContent")

        # @return [String] An Amazon marketplace identifier.
        attribute?(:marketplace_id, String, from: "MarketplaceId")
      end
    end
  end
end
