# frozen_string_literal: true

require "peddler/api"

module Peddler
  class API
    # Selling Partner API for Product Fees
    #
    # The Selling Partner API for Product Fees lets you programmatically retrieve estimated fees for a product. You can
    # then account for those fees in your pricing.
    class ProductFeesV0 < API
      # Returns the estimated fees for the item indicated by the specified seller SKU in the marketplace specified in
      # the request body.
      # @note The parameters associated with this operation may contain special characters that require URL encoding to
      #   call the API. To avoid errors with SKUs when encoding URLs, refer to [URL
      #   Encoding](https://developer-docs.amazon.com/sp-api/docs/url-encoding). You can call `getMyFeesEstimateForSKU`
      #   for an item on behalf of a selling partner before the selling partner sets the item's price. The selling
      #   partner can then take any estimated fees into account. Each fees estimate request must include an original
      #   identifier. This identifier is included in the fees estimate so that you can correlate a fees estimate with
      #   the original request.
      # @note This identifier value is used to identify an estimate. Actual costs may vary. Search "fees" in [Seller
      #   Central](https://sellercentral.amazon.com/) and consult the store-specific fee schedule for the most
      #   up-to-date information.
      # @note When sellers use the `getMyFeesEstimateForSKU` operation with their `SellerSKU`, they get accurate fees
      #   based on real item measurements, but only after they've sent their items to Amazon.
      #
      # @param [Hash] body
      # @param [String] seller_sku Used to identify an item in the given marketplace. SellerSKU is qualified by the
      #   seller's SellerId, which is included with every operation that you submit.
      # @return [Hash] The API response
      def get_my_fees_estimate_for_sku(body, seller_sku)
        path = "/products/fees/v0/listings/#{seller_sku}/feesEstimate"

        rate_limit(1.0).post(path, body:)
      end

      # Returns the estimated fees for the item indicated by the specified ASIN in the marketplace specified in the
      # request body. You can call `getMyFeesEstimateForASIN` for an item on behalf of a selling partner before the
      # selling partner sets the item's price. The selling partner can then take estimated fees into account. Each fees
      # request must include an original identifier. This identifier is included in the fees estimate so you can
      # correlate a fees estimate with the original request.
      # @note This identifier value is used to identify an estimate. Actual costs may vary. Search "fees" in [Seller
      #   Central](https://sellercentral.amazon.com/) and consult the store-specific fee schedule for the most
      #   up-to-date information.
      # @note When using the `getMyFeesEstimateForASIN` operation with an ASIN, the fee estimates might be different.
      #   This is because these estimates use the item's catalog size, which might not always match the actual size of
      #   the item sent to Amazon.
      #
      # @param [Hash] body
      # @param [String] asin The Amazon Standard Identification Number (ASIN) of the item.
      # @return [Hash] The API response
      def get_my_fees_estimate_for_asin(body, asin)
        path = "/products/fees/v0/items/#{asin}/feesEstimate"

        rate_limit(1.0).post(path, body:)
      end

      # Returns the estimated fees for a list of products.
      #
      # @param [Hash] body
      # @return [Hash] The API response
      def get_my_fees_estimates(body)
        path = "/products/fees/v0/feesEstimate"

        rate_limit(0.5).post(path, body:)
      end
    end
  end
end
