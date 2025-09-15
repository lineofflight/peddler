# frozen_string_literal: true

require "helper"
require "peddler/apis/product_fees_v0"

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
        res = api.sandbox.get_my_fees_estimate_for_sku(payload, nil)

        assert_predicate(res.status, :success?)
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
        res = api.sandbox.get_my_fees_estimate_for_asin(payload, nil)

        assert_predicate(res.status, :success?)
      end
    end
  end
end
