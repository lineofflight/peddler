# frozen_string_literal: true

require "helper"
require "peddler/apis/product_pricing_2022_05_01"

module Peddler
  module APIs
    class ProductPricing20220501Test < Minitest::Test
      include FeatureHelpers

      def test_get_featured_offer_expected_price_batch
        payload = {
          "requests" => [
            {
              "marketplaceId" => "MARKETPLACE_ID",
              "sku" => "MY_SKU",
              "segment" => {
                "segmentDetails" => {
                  "sampleLocation" => {
                    "postalCode" => {
                      "countryCode" => "COUNTRY_CODE",
                      "value" => "POSTAL_CODE_VALUE",
                    },
                  },
                },
              },
              "method" => "GET",
              "uri" => "/products/pricing/2022-05-01/offer/featuredOfferExpectedPrice",
            },
            {
              "marketplaceId" => "MARKETPLACE_ID",
              "sku" => "MY_UNIQUE_SKU",
              "method" => "GET",
              "uri" => "/products/pricing/2022-05-01/offer/featuredOfferExpectedPrice",
            },
            {
              "marketplaceId" => "MARKETPLACE_ID",
              "sku" => "INVALID_SKU",
              "method" => "GET",
              "uri" => "/products/pricing/2022-05-01/offer/featuredOfferExpectedPrice",
            },
          ],
        }
        res = api.sandbox.get_featured_offer_expected_price_batch(payload)

        assert_predicate(res.status, :success?)
      end

      def test_get_competitive_summary
        payload = {
          "requests" => [
            {
              "asin" => "B00ZIAODGE",
              "marketplaceId" => "ATVPDKIKX0DER",
              "includedData" => ["featuredBuyingOptions", "referencePrices", "lowestPricedOffers"],
              "lowestPricedOffersInputs" => [
                { "itemCondition" => "New", "offerType" => "Consumer" },
                { "itemCondition" => "Used", "offerType" => "Consumer" },
              ],
              "uri" => "/products/pricing/2022-05-01/items/competitiveSummary",
              "method" => "GET",
            },
            {
              "asin" => "11_AABB_123",
              "marketplaceId" => "ATVPDKIKX0DER",
              "includedData" => ["featuredBuyingOptions"],
              "uri" => "/products/pricing/2022-05-01/items/competitiveSummary",
              "method" => "GET",
            },
          ],
        }
        res = api.sandbox.get_competitive_summary(payload)

        assert_predicate(res.status, :success?)
      end
    end
  end
end
