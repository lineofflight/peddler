require 'peddler/parsers/model'
require 'mws/products/parsers/qualifiers'
require 'mws/products/parsers/price'

module MWS
  module Products
    module Parsers
      class LowestOfferListing < ::Peddler::Parsers::Model
        value :qualifiers do
          Qualifiers.new(xpath('Qualifiers'))
        end

        value :number_of_offer_listings_considered do
          integer_at_xpath('NumberOfOfferListingsConsidered')
        end

        value :seller_feedback_count do
          integer_at_xpath('SellerFeedbackCount')
        end

        value :price do
          Price.new(xpath('Price'))
        end

        value :multiple_offers_at_lowest_price do
          boolean_at_xpath('MultipleOffersAtLowestPrice')
        end
      end
    end
  end
end
