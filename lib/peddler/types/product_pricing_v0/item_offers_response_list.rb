# frozen_string_literal: true

require "peddler/types/product_pricing_v0/item_offers_response"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ProductPricingV0
      # A list of `getItemOffers` batched responses.
      class ItemOffersResponseList < Array
        class << self
          def parse(array)
            new(array.map { |item| ItemOffersResponse.parse(item) })
          end
        end
      end
    end
  end
end
