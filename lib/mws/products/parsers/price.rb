require 'peddler/parsers/model'

module MWS
  module Products
    module Parsers
      class Price < ::Peddler::Parsers::Model
        value :landed_price do
          money_at_xpath('LandedPrice')
        end

        value :listing_price do
          money_at_xpath('ListingPrice')
        end

        value :shipping do
          money_at_xpath('Shipping')
        end
      end
    end
  end
end
