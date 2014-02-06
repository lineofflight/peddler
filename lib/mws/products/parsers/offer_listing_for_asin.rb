require 'mws/products/parsers/product'
require 'peddler/parsers/model'

module MWS
  module Products
    module Parsers
      class OfferListingForASIN < ::Peddler::Parsers::Model
        value :status do
          attribute('status')
        end

        value :asin do
          attribute('ASIN')
        end

        value :all_offer_listings_considered do
          boolean_at_xpath('AllOfferListingsConsidered')
        end

        value :product do
          Product.new(xpath('Product'))
        end
      end
    end
  end
end
