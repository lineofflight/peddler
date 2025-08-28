# frozen_string_literal: true

require "peddler/api"

module Peddler
  class << self
    def product_pricing_2022_05_01(...)
      APIs::ProductPricing20220501.new(...)
    end
  end

  module APIs
    # Selling Partner API for Pricing
    #
    # The Selling Partner API for Pricing helps you programmatically retrieve product pricing and offer pricing
    # information for Amazon Marketplace products.
    #
    # For more information, refer to the [Product Pricing v2022-05-01 Use Case
    # Guide](https://developer-docs.amazon.com/sp-api/docs/product-pricing-api-v2022-05-01-use-case-guide).
    class ProductPricing20220501 < API
      # Returns the set of responses that correspond to the batched list of up to 40 requests defined in the request
      # body. The response for each successful (HTTP status code 200) request in the set includes the computed listing
      # price at or below which a seller can expect to become the featured offer (before applicable promotions). This is
      # called the featured offer expected price (FOEP). Featured offer is not guaranteed because competing offers might
      # change. Other offers might be featured based on factors such as fulfillment capabilities to a specific customer.
      # The response to an unsuccessful request includes the available error text.
      #
      # @note This operation can make a static sandbox call.
      # @param get_featured_offer_expected_price_batch_request_body [Hash] The batch of `getFeaturedOfferExpectedPrice`
      #   requests.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_featured_offer_expected_price_batch(get_featured_offer_expected_price_batch_request_body,
        rate_limit: 0.033)
        path = "/batches/products/pricing/2022-05-01/offer/featuredOfferExpectedPrice"
        body = get_featured_offer_expected_price_batch_request_body

        meter(rate_limit).post(path, body:)
      end

      # Returns the competitive summary response, including featured buying options for the ASIN and `marketplaceId`
      # combination.
      #
      # @note This operation can make a static sandbox call.
      # @param requests [Hash] The batch of `getCompetitiveSummary` requests.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_competitive_summary(requests, rate_limit: 0.033)
        path = "/batches/products/pricing/2022-05-01/items/competitiveSummary"
        body = requests

        meter(rate_limit).post(path, body:)
      end
    end
  end
end
