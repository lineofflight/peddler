# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module FulfillmentInboundV0
      # Contains detail about an invalid SKU
      InvalidSKU = Structure.new do
        # @return [String] The seller SKU of the item.
        attribute(:seller_sku, String, from: "SellerSKU")

        # @return [String] The reason why the seller SKU is invalid.
        attribute(:error_reason, String, from: "ErrorReason")
      end
    end
  end
end
