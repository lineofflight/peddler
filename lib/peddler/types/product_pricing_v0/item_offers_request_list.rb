# frozen_string_literal: true

require "peddler/types/product_pricing_v0/item_offers_request"

module Peddler
  module Types
    module ProductPricingV0
      # A list of `getListingOffers` batched requests to run.
      class ItemOffersRequestList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| ItemOffersRequest.parse(item) })
          end
        end
      end
    end
  end
end
