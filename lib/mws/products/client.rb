# frozen_string_literal: true

require 'peddler/client'

module MWS
  module Products
    # The MWS Products API helps you get information to match your products to
    # existing product listings on Amazon Marketplace websites and to make
    # sourcing and pricing decisions for listing those products on Amazon
    # Marketplace websites.
    class Client < ::Peddler::Client
      self.version = '2011-10-01'
      self.path = "/Products/#{version}"

      # Lists products and their attributes, based on a search query
      #
      # @see https://docs.developer.amazonservices.com/en_US/products/Products_ListMatchingProducts.html
      # @param [String] marketplace_id
      # @param [String] query
      # @param [Hash] opts
      # @option opts [String] :query_context_id
      # @return [Peddler::XMLParser]
      def list_matching_products(marketplace_id, query, opts = {})
        operation('ListMatchingProducts')
          .add(opts)
          .add('MarketplaceId' => marketplace_id, 'Query' => query)

        run
      end

      # Lists products and their attributes, based on a list of ASIN values
      #
      # @see https://docs.developer.amazonservices.com/en_US/products/Products_GetMatchingProductForId.html
      # @param [String] marketplace_id
      # @param [Array<String>] asin_list
      # @return [Peddler::XMLParser]
      def get_matching_product(marketplace_id, *asin_list)
        operation('GetMatchingProduct')
          .add('MarketplaceId' => marketplace_id, 'ASINList' => asin_list)
          .structure!('ASINList', 'ASIN')

        run
      end

      # Lists products and their attributes, based on a list of ASIN, GCID,
      #   SellerSKU, UPC, EAN, ISBN, and JAN values
      #
      # @see https://docs.developer.amazonservices.com/en_US/products/Products_GetMatchingProduct.html
      # @param [String] marketplace_id
      # @param [String] id_type
      # @param [Array<String>] id_list
      # @return [Peddler::XMLParser]
      def get_matching_product_for_id(marketplace_id, id_type, *id_list)
        operation('GetMatchingProductForId')
          .add('MarketplaceId' => marketplace_id, 'IdType' => id_type,
               'IdList' => id_list)
          .structure!('IdList', 'Id')

        run
      end

      # Gets the current competitive price of a product, based on Seller SKU
      #
      # @see https://docs.developer.amazonservices.com/en_US/products/Products_GetCompetitivePricingForSKU.html
      # @param [String] marketplace_id
      # @param [Array<String>] seller_sku_list
      # @return [Peddler::XMLParser]
      def get_competitive_pricing_for_sku(marketplace_id, *seller_sku_list)
        operation('GetCompetitivePricingForSKU')
          .add('MarketplaceId' => marketplace_id,
               'SellerSKUList' => seller_sku_list)
          .structure!('SellerSKUList', 'SellerSKU')

        run
      end

      # Gets the current competitive price of a product, identified by its ASIN
      #
      # @see https://docs.developer.amazonservices.com/en_US/products/Products_GetCompetitivePricingForASIN.html
      # @param [String] marketplace_id
      # @param [Array<String>] asin_list
      # @return [Peddler::XMLParser]
      def get_competitive_pricing_for_asin(marketplace_id, *asin_list)
        operation('GetCompetitivePricingForASIN')
          .add('MarketplaceId' => marketplace_id, 'ASINList' => asin_list)
          .structure!('ASINList', 'ASIN')

        run
      end

      # Gets pricing information for the lowest-price active offer listings for
      # a product, based on Seller SKU
      #
      # @see https://docs.developer.amazonservices.com/en_US/products/Products_GetLowestOfferListingsForSKU.html
      # @overload get_lowest_offer_listings_for_sku(marketplace_id, *seller_sku_list, opts = {})
      #   @param [String] marketplace_id
      #   @param [Array<String>] seller_sku_list
      #   @param [Hash] opts
      #   @option opts [String] :item_condition
      #   @option opts [Boolean] :exclude_me
      # @return [Peddler::XMLParser]
      def get_lowest_offer_listings_for_sku(marketplace_id, *seller_sku_list)
        seller_sku_list = seller_sku_list.dup
        opts = extract_options(seller_sku_list)

        operation('GetLowestOfferListingsForSKU')
          .add(opts)
          .add('MarketplaceId' => marketplace_id,
               'SellerSKUList' => seller_sku_list)
          .structure!('SellerSKUList', 'SellerSKU')

        run
      end

      # Gets pricing information for the lowest-price active offer listings for
      # a product, identified by its ASIN
      #
      # @see https://docs.developer.amazonservices.com/en_US/products/Products_GetLowestOfferListingsForASIN.html
      # @overload get_lowest_offers_listings_for_asin(marketplace_id, *asin_list, opts = {})
      #   @param [String] marketplace_id
      #   @param [Array<String>] asin_list
      #   @param [Hash] opts
      #   @option opts [String] :item_condition
      #   @option opts [Boolean] :exclude_me
      # @return [Peddler::XMLParser]
      def get_lowest_offer_listings_for_asin(marketplace_id, *asin_list)
        asin_list = asin_list.dup
        opts = extract_options(asin_list)

        operation('GetLowestOfferListingsForASIN')
          .add(opts)
          .add('MarketplaceId' => marketplace_id, 'ASINList' => asin_list)
          .structure!('ASINList', 'ASIN')

        run
      end

      # Gets lowest priced offers for a single product, based on SellerSKU
      #
      # @see https://docs.developer.amazonservices.com/en_MX/products/Products_GetLowestPricedOffersForSKU.html
      # @param [String] marketplace_id
      # @param [String] seller_sku
      # @param [String] item_condition
      # @return [Peddler::XMLParser]
      def get_lowest_priced_offers_for_sku(marketplace_id, seller_sku,
                                           item_condition)
        operation('GetLowestPricedOffersForSKU')
          .add('MarketplaceId' => marketplace_id, 'SellerSKU' => seller_sku,
               'ItemCondition' => item_condition)

        run
      end

      # Gets lowest priced offers for a single product, based on ASIN
      #
      # @see https://docs.developer.amazonservices.com/en_MX/products/Products_GetLowestPricedOffersForASIN.html
      # @param [String] marketplace_id
      # @param [String] asin
      # @param [String] item_condition
      # @return [Peddler::XMLParser]
      def get_lowest_priced_offers_for_asin(marketplace_id, asin,
                                            item_condition)
        operation('GetLowestPricedOffersForASIN')
          .add('MarketplaceId' => marketplace_id, 'ASIN' => asin,
               'ItemCondition' => item_condition)

        run
      end

      # Gets the estimated fees for a list of products.
      #
      # @see https://docs.developer.amazonservices.com/en_US/products/Products_GetMyFeesEstimate.html
      # @see https://docs.developer.amazonservices.com/en_US/products/Products_Datatypes.html#FeesEstimateRequest
      # @param [Array<Struct, Hash>] fees_estimate_requests
      # @return [Peddler::XMLParser]
      def get_my_fees_estimate(*fees_estimate_requests)
        operation('GetMyFeesEstimate')
          .add('FeesEstimateRequestList' => fees_estimate_requests)
          .structure!('FeesEstimateRequestList', 'FeesEstimateRequest')

        run
      end

      # Gets pricing information for seller's own offer listings, based on
      # Seller SKU
      #
      # @see https://docs.developer.amazonservices.com/en_US/products/Products_GetMyPriceForSKU.html
      # @overload get_my_price_for_sku(marketplace_id, *seller_sku_list,
      #   opts = {})
      #   @param [String] marketplace_id
      #   @param [Array<String>] seller_sku_list
      #   @param [Hash] opts
      #   @option opts [String] :item_condition
      # @return [Peddler::XMLParser]
      def get_my_price_for_sku(marketplace_id, *seller_sku_list)
        seller_sku_list = seller_sku_list.dup
        opts = extract_options(seller_sku_list)

        operation('GetMyPriceForSKU')
          .add(opts)
          .add('MarketplaceId' => marketplace_id,
               'SellerSKUList' => seller_sku_list)
          .structure!('SellerSKUList', 'SellerSKU')

        run
      end

      # Gets pricing information for seller's own offer listings, identified by
      # its ASIN
      #
      # @see https://docs.developer.amazonservices.com/en_US/products/Products_GetMyPriceForASIN.html
      # @overload get_my_price_for_asin(marketplace_id, *asin_list, opts = {})
      #   @param [String] marketplace_id
      #   @param [Array<String>] asin_list
      #   @param [Hash] opts
      #   @option opts [String] :item_condition
      # @return [Peddler::XMLParser]
      def get_my_price_for_asin(marketplace_id, *asin_list)
        asin_list = asin_list.dup
        opts = extract_options(asin_list)

        operation('GetMyPriceForASIN')
          .add(opts)
          .add('MarketplaceId' => marketplace_id,
               'ASINList' => asin_list)
          .structure!('ASINList', 'ASIN')

        run
      end

      # Gets parent product categories that a product belongs to, based on
      # Seller SKU
      #
      # @see https://docs.developer.amazonservices.com/en_US/products/Products_GetProductCategoriesForSKU.html
      # @param [String] marketplace_id
      # @param [String] seller_sku
      # @return [Peddler::XMLParser]
      def get_product_categories_for_sku(marketplace_id, seller_sku)
        operation('GetProductCategoriesForSKU')
          .add('MarketplaceId' => marketplace_id, 'SellerSKU' => seller_sku)

        run
      end

      # Gets parent product categories that a product belongs to, based on ASIN
      #
      # @see https://docs.developer.amazonservices.com/en_US/products/Products_GetProductCategoriesForASIN.html
      # @param [String] marketplace_id
      # @param [String] asin
      # @return [Peddler::XMLParser]
      def get_product_categories_for_asin(marketplace_id, asin)
        operation('GetProductCategoriesForASIN')
          .add('MarketplaceId' => marketplace_id, 'ASIN' => asin)

        run
      end

      # Gets the service status of the API
      #
      # @see https://docs.developer.amazonservices.com/en_US/products/Products_GetServiceStatus.html
      # @return [Peddler::XMLParser]
      def get_service_status
        operation('GetServiceStatus')
        run
      end
    end
  end
end
