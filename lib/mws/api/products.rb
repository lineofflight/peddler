module MWS
  module API
    module Products
      def get_lowest_offer_listings_for_asin(asins)
      end

      def products_url_builder
        builder = url_builder "https://#{@endpoint.host}/Products/2011-10-01"
        builder.update 'MarketplaceId' => @endpoint.marketplace_id

        builder
      end
    end
  end
end
