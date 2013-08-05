require 'peddler/service'

module Peddler
  # The Products API helps you get information to match your products to
  # existing product listings on Amazon Marketplace websites and to make
  # sourcing and pricing decisions for listing those products on Amazon
  # Marketplace websites.
  class Products < Service
    path 'Products/2011-10-01'

    # List matching products for a query.
    #
    # params - The Hash request parameters.
    #          :query            - A String search query.
    #          :query_context_id - A String query context id value (default:
    #                              'All').
    #
    # Returns a Peddler Response.
    def list_matching_products(params)
      post(
        'Action'         => 'ListMatchingProducts',
        'Query'          => params.fetch(:query),
        'QueryContextId' => params.fetch(:query_context_id, 'All')
      )
    end

    # Get matching products for a list of ASINs.
    #
    # params - The Hash request parameters.
    #          :asins - One or more String ASINs.
    #
    # Returns a Peddler Response.
    def get_matching_product(params)
      post(list('ASIN', params.fetch(:asins)).merge(
        'Action' => 'GetMatchingProduct'
      ))
    end

    # Get a matching products for a list of product identifiers.
    #
    # params - The Hash request parameters.
    #          :id_type - The String product id type, which can be one of ASIN,
    #                     GCID, SellerSKU, UPC, EAN, ISBN, and JAN values.
    #          :ids     - One or more String ids.
    #
    # Returns a Peddler Response.
    def get_matching_product_for_id(params)
      post(list('Id', params.fetch(:ids)).merge(
        'Action' => 'GetMatchingProductForId',
        'IdType' => params.fetch(:id_type)
      ))
    end

    # Get competitive prices for matching products for a list of seller SKUs.
    #
    # params - The Hash request parameters.
    #          :skus - One or more SKUs.
    #
    # Returns a Peddler Response.
    def get_competitive_pricing_for_sku(params)
      post(list('SellerSKU', params.fetch(:skus)).merge(
        'Action' => 'GetCompetitivePricingForSKU'
      ))
    end

    # Get competitive prices for matching products for a list of ASINs.
    #
    # params - The Hash request parameters.
    #          :asins - One or more String ASINs.
    #
    # Returns a Peddler Response.
    def get_competitive_pricing_for_asin(params)
      post(list('ASIN', params.fetch(:asins)).merge(
        'Action' => 'GetCompetitivePricingForASIN'
      ))
    end

    # Get pricing information for the lowest-price active offer listings for a
    # list of products, based on seller SKUs.
    #
    # params - The Hash request parameters.
    #          :skus           - One or more String SKUs.
    #          :item_condition - The String item condition, which may be one of
    #                            Any, New, Used, Collectible, Refurbished, and
    #                            Club (default: 'Any').
    #          :exclude_me     - Whether to exclude your own offer listings
    #                            from the offer listings that are returned
    #                            (default: false).
    #
    # Returns a Peddler Response.
    def get_lowest_offer_listings_for_sku(params)
      post(list('SellerSKU', params.fetch(:skus)).merge(
        'Action'        => 'GetLowestOfferListingsForSKU',
        'ItemCondition' => params.fetch(:item_condition, 'Any'),
        'ExcludeMe'     => params.fetch(:exclude_me, false)
      ))
    end

    # Get pricing information for the lowest-price active offer listings for a
    # list of products, based on ASINs.
    #
    # params - The Hash request parameters.
    #          :asins          - One or more String ASINs.
    #          :item_condition - The String item condition, which may be one of
    #                            Any, New, Used, Collectible, Refurbished, and
    #                            Club (default: 'Any').
    #          :exclude_me     - Whether to exclude your own offer listings
    #                            from the offer listings that are returned
    #                            (default: false).
    #
    # Returns a Peddler Response.
    def get_lowest_offer_listings_for_asin(params)
      post(list('ASIN', params.fetch(:asins)).merge(
        'Action'        => 'GetLowestOfferListingsForASIN',
        'ItemCondition' => params.fetch(:item_condition, 'Any'),
        'ExcludeMe'     => params.fetch(:exclude_me, false)
      ))
    end

    # Get pricing information for your own offer listings for a list of
    # products, based on seller SKUs.
    #
    # params - The Hash request parameters.
    #          :skus           - One or more String SKUs.
    #          :item_condition - The String item condition, which may be one of
    #                            Any, New, Used, Collectible, Refurbished, and
    #                            Club (default: 'Any').
    #
    # Returns a Peddler Response.
    def get_my_price_for_sku(params)
      post(list('SellerSKU', params.fetch(:skus)).merge(
        'Action'        => 'GetMyPriceForSKU',
        'ItemCondition' => params.fetch(:item_condition, 'Any')
      ))
    end

    # Get pricing information for your own offer listings for a list of
    # products, based on ASINs.
    #
    # params - The Hash request parameters.
    #          :asins          - One or more String ASINs.
    #          :item_condition - The String item condition, which may be one of
    #                            Any, New, Used, Collectible, Refurbished, and
    #                            Club (default: 'Any').
    #
    # Returns a Peddler Response.
    def get_my_price_for_asin(params)
      post(list('ASIN', params.fetch(:asins)).merge(
        'Action'        => 'GetMyPriceForASIN',
        'ItemCondition' => params.fetch(:item_condition, 'Any')
      ))
    end

    # Get the parent product categories that products belongs to, based on
    # their seller SKU.
    #
    # params - The Hash request parameters.
    #          :sku - A String SKU.
    #
    # Returns a Peddler Response.
    def get_product_categories_for_sku(params)
      post(
        'SellerSKU' => params.fetch(:sku),
        'Action'    => 'GetProductCategoriesForSKU'
      )
    end

    # Get the parent product categories that products belongs to, based on
    # their ASIN.
    #
    # params - The Hash request parameters.
    #          :asins - A String ASIN.
    #
    # Returns a Peddler Response.
    def get_product_categories_for_asin(params)
      post(
        'ASIN'   => params.fetch(:asin),
        'Action' => 'GetProductCategoriesForASIN'
      )
    end
  end
end
