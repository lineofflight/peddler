require 'peddler/parsers/model'

module MWS
  module Products
    module Parsers
      class LowestOfferListing < ::Peddler::Parsers::Model

        value :offer_listings_considered_count do
          integer_at_xpath('NumberOfOfferListingsConsidered')
        end

        value :seller_feedback_count do
          integer_at_xpath('SellerFeedbackCount')
        end

        value :multiple_offers do
          boolean_at_xpath('MultipleOffersAtLowestPrice')
        end

      end
    end
  end
end
