module MWS
  module API
    # The Amazon MWS Products API helps you get information to match your
    # products to existing product listings on Amazon Marketplace websites and
    # to make sourcing and pricing decisions for listing those products on
    # Amazon Marketplace websites.
    #
    # The Amazon MWS Products API returns product attributes, current
    # Marketplace pricing information, and a variety of other product and
    # listing information.
    module Products
      def get_competitive_pricing_for_asin
        raise NotImplementedError
      end

      def get_competitive_pricing_for_sku
        raise NotImplementedError
      end

      # Gets the lowest price offer listings for a product 
      #
      # asins     - A String or Array list of up to 20 ASINs.
      # condition - The String item condition scope (default: nil)
      #
      # Returns a MWS::Response.
      def get_lowest_offer_listings_for_asin(asins, condition = nil)
        params = build_list 'ASIN', asins
        params['ItemCondition'] = condition if condition
        url = products_url 'GetLowestOfferListingsForASIN', params

        res = Response.new connection.get url

        if res.valid?
          res
        else
          raise BadResponse, res.first('Error')['Message']
        end
      end

      def get_lowest_offer_listings_for_sku
        raise NotImplementedError
      end

      # Gets a list of products and their attributes.
      #
      # asins - A String or Array list of up to 10 ASINs.
      #
      # Returns a MWS::Response.
      #
      # Raises a BadResponse if response is not valid.
      def get_matching_product(asins)
        params = build_list 'ASIN', asins
        url = products_url 'GetMatchingProduct', params

        res = Response.new connection.get url

        if res.valid?
          res
        else
          raise BadResponse, res.first('Error')['Message']
        end
      end

      def get_my_price_for_asin
        raise NotImplementedError
      end

      def get_my_price_for_sku
        raise NotImplementedError
      end

      def get_product_categories_for_asin
        raise NotImplementedError
      end

      def get_product_categories_for_sku
        raise NotImplementedError
      end

      # Returns the String service status of the Products API.
      def get_service_status
        url = products_url 'GetServiceStatus'
        res = Response.new connection.get url

        if res.valid?
          res.first 'Status'
        else
          raise BadResponse, res.first('Error')['Message']
        end
      end

      def list_matching_products
        raise NotImplementedError
      end

      # Builds a MWS Products URL.
      #
      # action - The String action to perform.
      # params - A Hash of parameters (default: {}).
      #
      # Returns a String URL.
      def products_url(action, params = {})
        builder = url_builder "https://#{@endpoint.host}/Products/2011-10-01"
        builder.update 'Action'        => action,
                       'MarketplaceId' => @endpoint.marketplace_id,
                       'SellerId'      => @endpoint.seller_id

        builder.update(params).build :get
      end
    end
  end
end
