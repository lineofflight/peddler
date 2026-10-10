# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentInboundV0
      # Contains detail about an invalid SKU
      InvalidSKU = Structure.new do
        # The reason why the seller SKU is invalid.
        attribute?(:error_reason, String, from: "ErrorReason")

        # The seller SKU of the item.
        attribute?(:seller_sku, String, from: "SellerSKU")
      end
    end
  end
end
