# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ProductPricing20220501
      # Identifies an offer from a particular seller for a specified ASIN.
      OfferIdentifier = Structure.new do
        # The Amazon identifier for the item.
        attribute(:asin, String, null: false)

        # An Amazon store identifier.
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # The fulfillment type for the offer.
        attribute?(:fulfillment_type, String, from: "fulfillmentType")

        # The seller identifier for the offer.
        attribute?(:seller_id, String, from: "sellerId")

        # The seller SKU of the item. This will only be present for the target offer, which belongs to the requesting
        # seller.
        attribute?(:sku, String)
      end
    end
  end
end
