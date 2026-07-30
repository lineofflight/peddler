# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ListingsItems20210801
      # Offer details for a listings item for the specified Amazon store.
      ItemOfferByMarketplace = Structure.new do
        # @return [String] Amazon store identifier.
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # @return [String] The listings item's offer type.
        attribute(:offer_type, String, null: false, from: "offerType")

        # @return [Money] Purchase price of the listings item
        attribute(:price, Money, null: false)

        # @return [Audience] Buyer segment or program this offer is applicable to.
        attribute?(:audience, Audience)

        # @return [Points]
        attribute?(:points, Points)
      end
    end
  end
end
