# frozen_string_literal: true

require "peddler/api"

module Peddler
  class << self
    def product_pricing_v0(...)
      APIs::ProductPricingV0.new(...)
    end
  end

  module APIs
    # Selling Partner API for Pricing
    #
    # The Selling Partner API for Pricing helps you programmatically retrieve product pricing and offer information for
    # Amazon Marketplace products.
    class ProductPricingV0 < API
      # Returns pricing information for a seller's offer listings based on seller SKU or ASIN. **Note:** The parameters
      # associated with this operation may contain special characters that require URL encoding to call the API. To
      # avoid errors with SKUs when encoding URLs, refer to [URL
      # Encoding](https://developer-docs.amazon.com/sp-api/docs/url-encoding).
      #
      # @note This operation can make a static sandbox call.
      # @param marketplace_id [String] A marketplace identifier. Specifies the marketplace for which prices are
      #   returned.
      # @param asins [Array<String>] A list of up to twenty Amazon Standard Identification Number (ASIN) values used to
      #   identify items in the given marketplace.
      # @param skus [Array<String>] A list of up to twenty seller SKU values used to identify items in the given
      #   marketplace.
      # @param item_type [String] Indicates whether ASIN values or seller SKU values are used to identify items. If you
      #   specify Asin, the information in the response will be dependent on the list of Asins you provide in the Asins
      #   parameter. If you specify Sku, the information in the response will be dependent on the list of Skus you
      #   provide in the Skus parameter.
      # @param item_condition [String] Filters the offer listings based on item condition. Possible values: New, Used,
      #   Collectible, Refurbished, Club.
      # @param offer_type [String] Indicates whether to request pricing information for the seller's B2C or B2B offers.
      #   Default is B2C.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_pricing(marketplace_id, item_type, asins: nil, skus: nil, item_condition: nil, offer_type: nil,
        rate_limit: 0.5)
        path = "/products/pricing/v0/price"
        params = {
          "MarketplaceId" => marketplace_id,
          "Asins" => asins,
          "Skus" => skus,
          "ItemType" => item_type,
          "ItemCondition" => item_condition,
          "OfferType" => offer_type,
        }.compact

        meter(rate_limit).get(path, params:)
      end

      # Returns competitive pricing information for a seller's offer listings based on seller SKU or ASIN. **Note:** The
      # parameters associated with this operation may contain special characters that require URL encoding to call the
      # API. To avoid errors with SKUs when encoding URLs, refer to [URL
      # Encoding](https://developer-docs.amazon.com/sp-api/docs/url-encoding).
      #
      # @note This operation can make a static sandbox call.
      # @param marketplace_id [String] A marketplace identifier. Specifies the marketplace for which prices are
      #   returned.
      # @param asins [Array<String>] A list of up to twenty Amazon Standard Identification Number (ASIN) values used to
      #   identify items in the given marketplace.
      # @param skus [Array<String>] A list of up to twenty seller SKU values used to identify items in the given
      #   marketplace.
      # @param item_type [String] Indicates whether ASIN values or seller SKU values are used to identify items. If you
      #   specify Asin, the information in the response will be dependent on the list of Asins you provide in the Asins
      #   parameter. If you specify Sku, the information in the response will be dependent on the list of Skus you
      #   provide in the Skus parameter. Possible values: Asin, Sku.
      # @param customer_type [String] Indicates whether to request pricing information from the point of view of
      #   Consumer or Business buyers. Default is Consumer.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_competitive_pricing(marketplace_id, item_type, asins: nil, skus: nil, customer_type: nil, rate_limit: 0.5)
        path = "/products/pricing/v0/competitivePrice"
        params = {
          "MarketplaceId" => marketplace_id,
          "Asins" => asins,
          "Skus" => skus,
          "ItemType" => item_type,
          "CustomerType" => customer_type,
        }.compact

        meter(rate_limit).get(path, params:)
      end

      # Returns the lowest priced offers for a single SKU listing. **Note:** The parameters associated with this
      # operation may contain special characters that require URL encoding to call the API. To avoid errors with SKUs
      # when encoding URLs, refer to [URL Encoding](https://developer-docs.amazon.com/sp-api/docs/url-encoding).
      #
      # @note This operation can make a static sandbox call.
      # @param marketplace_id [String] A marketplace identifier. Specifies the marketplace for which prices are
      #   returned.
      # @param item_condition [String] Filters the offer listings based on item condition. Possible values: New, Used,
      #   Collectible, Refurbished, Club.
      # @param seller_sku [String] Identifies an item in the given marketplace. SellerSKU is qualified by the seller's
      #   SellerId, which is included with every operation that you submit.
      # @param customer_type [String] Indicates whether to request Consumer or Business offers. Default is Consumer.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_listing_offers(marketplace_id, item_condition, seller_sku, customer_type: nil, rate_limit: 1.0)
        path = "/products/pricing/v0/listings/#{seller_sku}/offers"
        params = {
          "MarketplaceId" => marketplace_id,
          "ItemCondition" => item_condition,
          "CustomerType" => customer_type,
        }.compact

        meter(rate_limit).get(path, params:)
      end

      # Returns the lowest priced offers for a single item based on ASIN.
      #
      # @note This operation can make a static sandbox call.
      # @param marketplace_id [String] A marketplace identifier. Specifies the marketplace for which prices are
      #   returned.
      # @param item_condition [String] Filters the offer listings to be considered based on item condition. Possible
      #   values: New, Used, Collectible, Refurbished, Club.
      # @param asin [String] The Amazon Standard Identification Number (ASIN) of the item.
      # @param customer_type [String] Indicates whether to request Consumer or Business offers. Default is Consumer.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_item_offers(marketplace_id, item_condition, asin, customer_type: nil, rate_limit: 0.5)
        path = "/products/pricing/v0/items/#{asin}/offers"
        params = {
          "MarketplaceId" => marketplace_id,
          "ItemCondition" => item_condition,
          "CustomerType" => customer_type,
        }.compact

        meter(rate_limit).get(path, params:)
      end

      # Returns the lowest priced offers for a batch of items based on ASIN.
      #
      # @note This operation can make a static sandbox call.
      # @param get_item_offers_batch_request_body [Hash] The request associated with the `getItemOffersBatch` API call.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_item_offers_batch(get_item_offers_batch_request_body, rate_limit: 0.1)
        path = "/batches/products/pricing/v0/itemOffers"
        body = get_item_offers_batch_request_body

        meter(rate_limit).post(path, body:)
      end

      # Returns the lowest priced offers for a batch of listings by SKU.
      #
      # @note This operation can make a static sandbox call.
      # @param get_listing_offers_batch_request_body [Hash] The request associated with the `getListingOffersBatch` API
      #   call.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_listing_offers_batch(get_listing_offers_batch_request_body, rate_limit: 0.5)
        path = "/batches/products/pricing/v0/listingOffers"
        body = get_listing_offers_batch_request_body

        meter(rate_limit).post(path, body:)
      end
    end
  end
end
