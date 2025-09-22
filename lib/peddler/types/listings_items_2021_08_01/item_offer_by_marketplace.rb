# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/money"
require "peddler/types/listings_items_2021_08_01/points"
require "peddler/types/listings_items_2021_08_01/audience"

module Peddler
  module Types
    module ListingsItems20210801
      # Offer details of a listings item for an Amazon marketplace.
      ItemOfferByMarketplace = Structure.new do
        # @return [String] The Amazon marketplace identifier.
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [String] Type of offer for the listings item.
        attribute(:offer_type, String, from: "offerType")

        # @return [Money] The purchase price of the listings item
        attribute(:price, Money)

        # @return [Points]
        attribute(:points, Points)

        # @return [Audience] Buyer segment or program this offer is applicable to.
        attribute(:audience, Audience)
      end
    end
  end
end
