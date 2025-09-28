# frozen_string_literal: true

require "peddler/types/product_pricing_v0/item_offers_request"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ProductPricingV0
      # A list of `getListingOffers` batched requests to run.
      class ItemOffersRequestList < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| ItemOffersRequest.parse(item) }) : new
          end
        end
      end
    end
  end
end
