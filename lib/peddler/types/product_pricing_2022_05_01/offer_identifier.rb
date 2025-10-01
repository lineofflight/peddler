# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module ProductPricing20220501
      # Identifies an offer from a particular seller for a specified ASIN.
      OfferIdentifier = Structure.new do
        # @return [String] The Amazon identifier for the item.
        attribute(:asin, String)

        # @return [String] A marketplace identifier.
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [String] The fulfillment type for the offer.
        attribute?(:fulfillment_type, String, from: "fulfillmentType")

        # @return [String] The seller identifier for the offer.
        attribute?(:seller_id, String, from: "sellerId")

        # @return [String] The seller SKU of the item. This will only be present for the target offer, which belongs to
        # the requesting seller.
        attribute?(:sku, String)
      end
    end
  end
end
