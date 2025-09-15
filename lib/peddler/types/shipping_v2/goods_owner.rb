# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module ShippingV2
      # The seller owning the goods before handing them over to the carrier
      GoodsOwner = Structure.new do
        # @return [String] The Amazon Merchant Identifier (merchantId) of the seller owning the goods before handing
        # them over to the carrier
        attribute(:merchant_id, String, from: "merchantId")
      end
    end
  end
end
