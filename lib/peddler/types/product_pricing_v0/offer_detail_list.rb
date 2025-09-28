# frozen_string_literal: true

require "peddler/types/product_pricing_v0/offer_detail"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ProductPricingV0
      # A list of offer details. The list is the same length as the TotalOfferCount in the Summary or 20, whichever is
      # less.
      class OfferDetailList < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| OfferDetail.parse(item) }) : new
          end
        end
      end
    end
  end
end
