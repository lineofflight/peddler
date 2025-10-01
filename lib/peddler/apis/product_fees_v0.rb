# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/api"

module Peddler
  class << self
    def product_fees_v0(...)
      APIs::ProductFeesV0.new(...)
    end
  end

  module APIs
    # Selling Partner API for Product Fees
    #
    # The Selling Partner API for Product Fees lets you programmatically retrieve estimated fees for a product. You can
    # then account for those fees in your pricing.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/product-fees-api-model/productFeesV0.json
    class ProductFeesV0 < API
      # Returns the estimated fees for the item indicated by the specified seller SKU in the marketplace specified in
      # the request body.
      #
      # **Note:** The parameters associated with this operation may contain special characters that require URL encoding
      # to call the API. To avoid errors with SKUs when encoding URLs, refer to [URL
      # Encoding](https://developer-docs.amazon.com/sp-api/docs/url-encoding).
      #
      # You can call `getMyFeesEstimateForSKU` for an item on behalf of a selling partner before the selling partner
      # sets the item's price. The selling partner can then take any estimated fees into account. Each fees estimate
      # request must include an original identifier. This identifier is included in the fees estimate so that you can
      # correlate a fees estimate with the original request.
      #
      # **Note:** This identifier value is used to identify an estimate. Actual costs may vary. Search "fees" in [Seller
      # Central](https://sellercentral.amazon.com/) and consult the store-specific fee schedule for the most up-to-date
      # information.
      #
      # **Note:** When sellers use the `getMyFeesEstimateForSKU` operation with their `SellerSKU`, they get accurate
      # fees based on real item measurements, but only after they've sent their items to Amazon.
      #
      # @note This operation can make a static sandbox call.
      # @param body [Hash] The request body schema for the getMyFeesEstimates operation
      # @param seller_sku [String] Used to identify an item in the given marketplace. SellerSKU is qualified by the
      #   seller's SellerId, which is included with every operation that you submit.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_my_fees_estimate_for_sku(body, seller_sku, rate_limit: 1.0)
        path = "/products/fees/v0/listings/#{percent_encode(seller_sku)}/feesEstimate"
        parser = Peddler::Types::ProductFeesV0::GetMyFeesEstimateResponse if typed?
        meter(rate_limit).post(path, body:, parser:)
      end

      # Returns the estimated fees for the item indicated by the specified ASIN in the marketplace specified in the
      # request body.
      #
      # You can call `getMyFeesEstimateForASIN` for an item on behalf of a selling partner before the selling partner
      # sets the item's price. The selling partner can then take estimated fees into account. Each fees request must
      # include an original identifier. This identifier is included in the fees estimate so you can correlate a fees
      # estimate with the original request.
      #
      # **Note:** This identifier value is used to identify an estimate. Actual costs may vary. Search "fees" in [Seller
      # Central](https://sellercentral.amazon.com/) and consult the store-specific fee schedule for the most up-to-date
      # information.
      #
      # **Note:** When using the `getMyFeesEstimateForASIN` operation with an ASIN, the fee estimates might be
      # different. This is because these estimates use the item's catalog size, which might not always match the actual
      # size of the item sent to Amazon.
      #
      # @note This operation can make a static sandbox call.
      # @param body [Hash] The request body schema for the getMyFeesEstimates operation
      # @param asin [String] The Amazon Standard Identification Number (ASIN) of the item.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_my_fees_estimate_for_asin(body, asin, rate_limit: 1.0)
        path = "/products/fees/v0/items/#{percent_encode(asin)}/feesEstimate"
        parser = Peddler::Types::ProductFeesV0::GetMyFeesEstimateResponse if typed?
        meter(rate_limit).post(path, body:, parser:)
      end

      # Returns the estimated fees for a list of products.
      #
      # @note This operation can make a static sandbox call.
      # @param body [Hash] The request body schema for the getMyFeesEstimates operation
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_my_fees_estimates(body, rate_limit: 0.5)
        path = "/products/fees/v0/feesEstimate"
        parser = Peddler::Types::ProductFeesV0::GetMyFeesEstimatesResponse if typed?
        meter(rate_limit).post(path, body:, parser:)
      end

      private

      def load_types
        require "peddler/types/product_fees_v0"
      end
    end
  end
end
