# frozen_string_literal: true

require "peddler/types/listings_items_2021_08_01/item_offer_by_marketplace"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ListingsItems20210801
      # Offer details for the listings item.
      class ItemOffers < Array
        class << self
          def parse(array)
            new(array.map { |item| ItemOfferByMarketplace.parse(item) })
          end
        end
      end
    end
  end
end
