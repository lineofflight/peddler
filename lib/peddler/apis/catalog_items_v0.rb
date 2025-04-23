
require "peddler/api"


module Peddler
  class << self
    def catalog_items_v0(...)
      APIs::CatalogItemsV0.new(...)
    end
  end

  module APIs
        # Selling Partner API for Catalog Items
    #
        # The Selling Partner API for Catalog Items helps you programmatically retrieve item details for items in the
    # catalog.
    class CatalogItemsV0 < API
      
      
              # Effective September 30, 2022, the `listCatalogItems` operation will no longer be available in the Selling
      # Partner API for Catalog Items v0. As an alternative, `searchCatalogItems` is available in the latest version of
      # the {https://developer-docs.amazon.com/sp-api/docs/catalog-items-api-v2022-04-01-reference Selling Partner API
      # for Catalog Items v2022-04-01}. Integrations that rely on the `listCatalogItems` operation should migrate to the
      # `searchCatalogItems`operation to avoid service disruption. _Note:_ The
      # [`listCatalogCategories`](#get-catalogv0categories) operation is not being deprecated and you can continue to
      # make calls to it.
#
        # @note This operation can make a static sandbox call.
        # @param marketplace_id [String] A marketplace identifier. Specifies the marketplace for which items are returned.
        # @param query [String] Keyword(s) to use to search for items in the catalog. Example: 'harry potter books'.
        # @param query_context_id [String] An identifier for the context within which the given search will be performed.
      #   A marketplace might provide mechanisms for constraining a search to a subset of potential items. For example,
      #   the retail marketplace allows queries to be constrained to a specific category. The QueryContextId parameter
      #   specifies such a subset. If it is omitted, the search will be performed using the default context for the
      #   marketplace, which will typically contain the largest set of items.
        # @param seller_sku [String] Used to identify an item in the given marketplace. SellerSKU is qualified by the
      #   seller's SellerId, which is included with every operation that you submit.
        # @param upc [String] A 12-digit bar code used for retail packaging.
        # @param ean [String] A European article number that uniquely identifies the catalog item, manufacturer, and its
      #   attributes.
        # @param isbn [String] The unique commercial book identifier used to identify books internationally.
        # @param jan [String] A Japanese article number that uniquely identifies the product, manufacturer, and its
      #   attributes.
        # @return [Peddler::Response] The API response
      def list_catalog_items(marketplace_id, query: nil, query_context_id: nil, seller_sku: nil, upc: nil, ean: nil,
        isbn: nil, jan: nil)
path = "/catalog/v0/items"
  params = {
      "MarketplaceId" => marketplace_id,
      "Query" => query,
      "QueryContextId" => query_context_id,
      "SellerSKU" => seller_sku,
      "UPC" => upc,
      "EAN" => ean,
      "ISBN" => isbn,
      "JAN" => jan,
    }.compact

  get(path, params:)

end

      
              # Effective September 30, 2022, the `getCatalogItem` operation will no longer be available in the Selling Partner
      # API for Catalog Items v0. This operation is available in the latest version of the
      # {https://developer-docs.amazon.com/sp-api/docs/catalog-items-api-v2022-04-01-reference Selling Partner API for
      # Catalog Items v2022-04-01}. Integrations that rely on this operation should migrate to the latest version to
      # avoid service disruption. _Note:_ The [`listCatalogCategories`](#get-catalogv0categories) operation is not being
      # deprecated and you can continue to make calls to it.
#
        # @note This operation can make a static sandbox call.
        # @param marketplace_id [String] A marketplace identifier. Specifies the marketplace for the item.
        # @param asin [String] The Amazon Standard Identification Number (ASIN) of the item.
        # @return [Peddler::Response] The API response
      def get_catalog_item(marketplace_id, asin)
path = "/catalog/v0/items/#{asin}"
  params = {
      "MarketplaceId" => marketplace_id,
    }.compact

  get(path, params:)

end

      
              # Returns the parent categories to which an item belongs, based on the specified ASIN or SellerSKU.
#
        # @note This operation can make a static sandbox call.
        # @param marketplace_id [String] A marketplace identifier. Specifies the marketplace for the item.
        # @param asin [String] The Amazon Standard Identification Number (ASIN) of the item.
        # @param seller_sku [String] Used to identify items in the given marketplace. SellerSKU is qualified by the
      #   seller's SellerId, which is included with every operation that you submit.
        # @param rate_limit [Float] Requests per second
        # @return [Peddler::Response] The API response
      def list_catalog_categories(marketplace_id, asin: nil, seller_sku: nil, rate_limit: 1.0)
path = "/catalog/v0/categories"
  params = {
      "MarketplaceId" => marketplace_id,
      "ASIN" => asin,
      "SellerSKU" => seller_sku,
    }.compact

  meter(rate_limit).get(path, params:)

end

      
    end
  end
end
