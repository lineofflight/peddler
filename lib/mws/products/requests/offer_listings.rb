require 'peddler/request'

module MWS
  module Products
    module OfferListings < ::Peddler::Request

      def get_lowest_for_sku(options = {})
        options[:marketplace_id] ||= client.marketplace_id
        parameters(:get_lowest_offer_listings_for_sku)
          .update(options)
          .camelize_keys!

        execute
      end

    end
  end
end
