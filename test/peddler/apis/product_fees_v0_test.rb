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
        # v5 recorded this with an empty SKU
        res = api.get_my_fees_estimate_for_sku(payload, "")

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
        res = api.get_my_fees_estimate_for_asin(payload, "")

        assert_success(res)
      end
    end
  end
end
