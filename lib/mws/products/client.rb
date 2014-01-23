require 'mws/products/requests/offer_listings'
require 'mws/products/parsers/offer_listings'
require 'mws/products/parsers/product'
require 'mws/products/parsers/identifiers'

module MWS
  module Products
    class Client < ::Peddler::Client
      path 'Products/2011-10-01'

      def_delegator :offer_listings, :get_lowest_for_sku, :get_lowest_offer_listings_for_sku

      private

      def offer_listings
        @offer_listings ||= Requests::OfferListings.new(self)
      end

    end
  end
end
