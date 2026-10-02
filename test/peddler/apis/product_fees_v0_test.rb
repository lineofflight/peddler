# frozen_string_literal: true

require "helper"

module Peddler
  module APIs
    class ProductFeesV0Test < Minitest::Test
      include FeatureHelpers

      def test_get_my_fees_estimate_for_sku
        payload = {
          "FeesEstimateRequest": {
            "MarketplaceId": "ATVPDKIKX0DER",
            "IsAmazonFulfilled": false,
            "PriceToEstimateFees": {
              "ListingPrice": {
                "CurrencyCode": "USD",
                "Amount": 10,
              },
              "Shipping": {
                "CurrencyCode": "USD",
                "Amount": 10,
              },
              "Points": {
                "PointsNumber": 0,
                "PointsMonetaryValue": {
                  "CurrencyCode": "USD",
                  "Amount": 0,
                },
              },
            },
            "Identifier": "UmaS1",
          },
        }
        # v5 recorded this with an empty SKU. The generated method rejects one before any request, so the
        # recording is replayed through a raw request under the same operation.
        assert_raises(ArgumentError) { api.get_my_fees_estimate_for_sku(seller_sku: "", body: payload) }
        res = client.request("POST", "/products/fees/v0/listings//feesEstimate", body: payload,
          operation: "product_fees_v0.get_my_fees_estimate_for_sku")

        assert_success(res)
      end

      def test_get_my_fees_estimate_for_asin
        payload = {
          "FeesEstimateRequest": {
            "MarketplaceId": "ATVPDKIKX0DER",
            "IsAmazonFulfilled": false,
            "PriceToEstimateFees": {
              "ListingPrice": {
                "CurrencyCode": "USD",
                "Amount": 10,
              },
              "Shipping": {
                "CurrencyCode": "USD",
                "Amount": 10,
              },
              "Points": {
                "PointsNumber": 0,
                "PointsMonetaryValue": {
                  "CurrencyCode": "USD",
                  "Amount": 0,
                },
              },
            },
            "Identifier": "UmaS1",
          },
        }
        # Recorded with an empty ASIN, as above
        assert_raises(ArgumentError) { api.get_my_fees_estimate_for_asin(asin: "", body: payload) }
        res = client.request("POST", "/products/fees/v0/items//feesEstimate", body: payload,
          operation: "product_fees_v0.get_my_fees_estimate_for_asin")

        assert_success(res)
      end
    end
  end
end
