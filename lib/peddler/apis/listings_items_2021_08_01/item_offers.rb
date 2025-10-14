# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class ListingsItems20210801
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
