require 'mws/products/requests/offer_listings_for_asin'
require 'mws/products/requests/offer_listings_for_sku'
require 'peddler/client'

module MWS
  module Products
    # The MWS Products API helps you get information to match your products to
    # existing product listings on Amazon Marketplace websites and to make
    # sourcing and pricing decisions for listing those products on Amazon
    # Marketplace websites.
    class Client < ::Peddler::Client
      path 'Products/2011-10-01'

      # Public: Gets pricing information for the lowest-price active offer
      # listings for a product, based on seller SKUs.
      #
      # seller_skus - One or more String seller SKUs.
      # options     - An optional Hash used to narrow the list.
      #               :marketplace_id - A String marketplace identifier.
      #               :item_condition - A String item condition.
      #               :exclude_me     - A Boolean that specifies whether to
      #                                 exclude one's own listings.
      #
      # The marketplace, if not given, defaults to the default country of the
      # client.
      #
      # Examples
      #
      #   client.get_lowest_offer_listings_for_sku('123')
      #
      # Returns an enumerable list of Offer Listings for SKU.
      def_delegator :offer_listings_for_sku, :get_lowest, :get_lowest_offer_listings_for_sku

      # Public: Gets pricing information for the lowest-price active offer
      # listings for a product, identified by its MarketplaceId and ASIN.
      #
      # asins    - One or more String seller ASINs.
      # options  - An optional Hash used to narrow the list.
      #            :marketplace_id - A String marketplace identifier.
      #            :item_condition - A String item condition.
      #            :exclude_me     - A Boolean that specifies whether to
      #                              exclude one's own listings.
      #
      # The marketplace, if not given, defaults to the default country of the
      # client.
      #
      # Examples
      #
      #   client.get_lowest_offer_listings_for_asin('1234567890', '0987654321')
      #
      # Returns an enumerable list of Offer Listings for ASIN.
      def_delegator :offer_listings_for_asin, :get_lowest, :get_lowest_offer_listings_for_asin

      private

      def offer_listings_for_asin
        @offer_listings_for_asin ||= Requests::OfferListingsForASIN.new(self)
      end

      def offer_listings_for_sku
        @offer_listings_for_sku ||= Requests::OfferListingsForSKU.new(self)
      end
    end
  end
end
