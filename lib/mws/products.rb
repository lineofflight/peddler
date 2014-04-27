require 'peddler/client'

module MWS
  # The MWS Products API helps you get information to match your products to
  # existing product listings on Amazon Marketplace websites and to make
  # sourcing and pricing decisions for listing those products on Amazon
  # Marketplace websites.
  class Products < ::Peddler::Client
    path '/Products/2011-10-01'

    # Lists products and their attributes, based on a search query
    #
    # @see http://docs.developer.amazonservices.com/en_US/products/Products_ListMatchingProducts.html
    # @overload list_matching_products(query, opts = { marketplace_id: marketplace_id })
    #   @param query [String]
    #   @param opts [Hash]
    #   @option opts [String] :marketplace_id
    #   @option opts [String] :query_context_id
    # @return [Peddler::XMLParser]
    def list_matching_products(query, opts = {})
      operation('ListMatchingProducts')
        .add(opts.merge('Query' => query))

      run
    end

    # Lists products and their attributes, based on a list of ASIN, GCID,
    #   SellerSKU, UPC, EAN, ISBN, and JAN values
    #
    # @see http://docs.developer.amazonservices.com/en_US/products/Products_GetMatchingProduct.html
    # @overload get_matching_product_for_id(id_type, *id_list, opts = { marketplace_id: marketplace_id })
    #   @param id_type [String]
    #   @param id_list [Array<String>]
    #   @param opts [Hash]
    #   @option opts [String] :marketplace_id
    # @return [Peddler::XMLParser]
    def get_matching_product_for_id(id_type, *id_list)
      opts = extract_options(id_list)

      operation('GetMatchingProductForId')
        .add(opts.merge('IdType' => id_type, 'IdList' => id_list))
        .structure!('IdList', 'Id')

      run
    end

    # Lists products and their attributes, based on a list of ASIN values
    #
    # @see http://docs.developer.amazonservices.com/en_US/products/Products_GetMatchingProductForId.html
    # @overload get_matching_product(*asins, opts = { marketplace_id: marketplace_id })
    #   @param asins [Array<String>]
    #   @param opts [Hash]
    #   @option opts [String] :marketplace_id
    # @return [Peddler::XMLParser]
    def get_matching_product(*asins)
      opts = extract_options(asins)

      operation('GetMatchingProduct')
        .add(opts.merge('ASINList' => asins))
        .structure!('ASINList', 'ASIN')

      run
    end

    # Gets the current competitive price of a product, based on Seller SKU
    #
    # @see http://docs.developer.amazonservices.com/en_US/products/Products_GetCompetitivePricingForSKU.html
    # @overload get_competitive_pricing_for_sku(*skus, opts = { marketplace_id: marketplace_id })
    #   @param skus [Array<String>]
    #   @param opts [Hash]
    #   @option opts [String] :marketplace_id
    # @return [Peddler::XMLParser]
    def get_competitive_pricing_for_sku(*skus)
      opts = extract_options(skus)

      operation('GetCompetitivePricingForSKU')
        .add(opts.merge('SellerSKUList' => skus))
        .structure!('SellerSKUList', 'SellerSKU')

      run
    end

    # Gets the current competitive price of a product, identified by its ASIN
    #
    # @see http://docs.developer.amazonservices.com/en_US/products/Products_GetCompetitivePricingForASIN.html
    # @overload get_competitive_pricing_for_asin(*asins, opts = { marketplace_id: marketplace_id })
    #   @param asins [Array<String>]
    #   @param opts [Hash]
    #   @option opts [String] :marketplace_id
    # @return [Peddler::XMLParser]
    def get_competitive_pricing_for_asin(*asins)
      opts = extract_options(asins)

      operation('GetCompetitivePricingForASIN')
        .add(opts.merge('ASINList' => asins))
        .structure!('ASINList', 'ASIN')

      run
    end

    # Gets pricing information for the lowest-price active offer listings for a
    # product, based on Seller SKU
    #
    # @see http://docs.developer.amazonservices.com/en_US/products/Products_GetLowestOfferListingsForSKU.html
    # @overload get_lowest_offer_listings_for_sku(*skus, opts = { marketplace_id: marketplace_id })
    #   @param skus [Array<String>]
    #   @param opts [Hash]
    #   @option opts [String] :marketplace_id
    #   @option opts [String] :item_condition
    #   @option opts [Boolean] :exclude_me
    # @return [Peddler::XMLParser]
    def get_lowest_offer_listings_for_sku(*skus)
      opts = extract_options(skus)

      operation('GetLowestOfferListingsForSKU')
        .add(opts.merge('SellerSKUList' => skus))
        .structure!('SellerSKUList', 'SellerSKU')

      run
    end

    # Gets pricing information for the lowest-price active offer listings for a
    # product, identified by its ASIN
    #
    # @see http://docs.developer.amazonservices.com/en_US/products/Products_GetLowestOfferListingsForASIN.html
    # @overload get_lowest_offer_listings_for_asin(*asins, opts = { marketplace_id: marketplace_id })
    #   @param asins [Array<String>]
    #   @param opts [Hash]
    #   @option opts [String] :marketplace_id
    #   @option opts [String] :item_condition
    #   @option opts [Boolean] :exclude_me
    # @return [Peddler::XMLParser]
    def get_lowest_offer_listings_for_asin(*asins)
      opts = extract_options(asins)

      operation('GetLowestOfferListingsForASIN')
        .add(opts.merge('ASINList' => asins))
        .structure!('ASINList', 'ASIN')

      run
    end

    # Gets pricing information for seller's own offer listings, based on Seller
    # SKU
    #
    # @see http://docs.developer.amazonservices.com/en_US/products/Products_GetMyPriceForSKU.html
    # @overload get_my_price_for_sku(*skus, opts = { marketplace_id: marketplace_id })
    #   @param skus [Array<String>]
    #   @param opts [Hash]
    #   @option opts [String] :marketplace_id
    #   @option opts [String] :item_condition
    # @return [Peddler::XMLParser]
    def get_my_price_for_sku(*skus)
      opts = extract_options(skus)

      operation('GetMyPriceForSKU')
        .add(opts.merge('SellerSKUList' => skus))
        .structure!('SellerSKUList', 'SellerSKU')

      run
    end

    # Gets pricing information for seller's own offer listings, identified by
    # its ASIN
    #
    # @see http://docs.developer.amazonservices.com/en_US/products/Products_GetMyPriceForASIN.html
    # @overload get_my_price_for_asin(*skus, opts = { marketplace_id: marketplace_id })
    #   @param asins [Array<String>]
    #   @param opts [Hash]
    #   @option opts [String] :marketplace_id
    #   @option opts [String] :item_condition
    # @return [Peddler::XMLParser]
    def get_my_price_for_asin(*asins)
      opts = extract_options(asins)

      operation('GetMyPriceForASIN')
        .add(opts.merge('ASINList' => asins))
        .structure!('ASINList', 'ASIN')

      run
    end

    # Gets parent product categories that a product belongs to, based on
    # Seller`SKU
    #
    # @see http://docs.developer.amazonservices.com/en_US/products/Products_GetProductCategoriesForSKU.html
    # @overload get_product_categories_for_sku(sku, opts = { marketplace_id: marketplace_id })
    #   @param sku [String]
    #   @param opts [Hash]
    #   @option opts [String] :marketplace_id
    # @return [Peddler::XMLParser]
    def get_product_categories_for_sku(sku, opts = {})
      operation('GetProductCategoriesForSKU')
        .add(opts.merge('SellerSKU' => sku))

      run
    end

    # Gets parent product categories that a product belongs to, based on ASIN
    #
    # @see http://docs.developer.amazonservices.com/en_US/products/Products_GetProductCategoriesForASIN.html
    # @overload get_product_categories_for_asin(asin, opts = { marketplace_id: marketplace_id })
    #   @param asin [String]
    #   @param opts [Hash]
    #   @option opts [String] :marketplace_id
    # @return [Peddler::XMLParser]
    def get_product_categories_for_asin(asin, opts = {})
      operation('GetProductCategoriesForASIN')
        .add(opts.merge('ASIN' => asin))

      run
    end

    # Gets the service status of the API
    #
    # @see http://docs.developer.amazonservices.com/en_US/products/Products_GetServiceStatus.html
    # @return [Peddler::XMLParser]
    def get_service_status
      operation('GetServiceStatus')
      run
    end

    def operation(*)
      super.tap do |opts|
        unless opts.has_key?('MarketplaceId')
          opts.store('MarketplaceId', marketplace_id)
        end
      end
    end
  end
end
