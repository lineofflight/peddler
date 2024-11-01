# frozen_string_literal: true

require "helper"

require "peddler/apis/product_pricing_2022_05_01"

module Peddler
  class API
    class ProductPricing20220501Test < Minitest::Test
      include FeatureHelpers

      def test_get_featured_offer_expected_price_batch
        batch = {
          "requests" => [
            {
              "uri" => "/products/pricing/2022-05-01/offer/featuredOfferExpectedPrice",
              "method" => "GET",
              "marketplaceId" => Marketplace.id("UK"),
              "sku" => "TSY-IBT-IL2",
            },
            {
              "uri" => "/products/pricing/2022-05-01/offer/featuredOfferExpectedPrice",
              "method" => "GET",
              "marketplaceId" => Marketplace.id("UK"),
              "sku" => "SM-2DHM-HZJF",
            },
            {
              "uri" => "/products/pricing/2022-05-01/offer/featuredOfferExpectedPrice",
              "method" => "GET",
              "marketplaceId" => Marketplace.id("UK"),
              "sku" => "Q0-I4ZH-B6JS",
            },
            {
              "uri" => "/products/pricing/2022-05-01/offer/featuredOfferExpectedPrice",
              "method" => "GET",
              "marketplaceId" => Marketplace.id("UK"),
              "sku" => "G1-MPH9-Y7RX",
            },
          ],
        }
        res = api.get_featured_offer_expected_price_batch(batch)

        assert_predicate(res.status, :ok?)
      end

      def test_get_competitive_summary
        batch = {
          requests: [
            {
              uri: "/products/pricing/2022-05-01/items/competitiveSummary",
              method: "GET",
              asin: "188864544X",
              marketplaceId: Marketplace.id("UK"),
              includedData: ["featuredBuyingOptions", "referencePrices", "lowestPricedOffers"],
            },
            {
              uri: "/products/pricing/2022-05-01/items/competitiveSummary",
              method: "GET",
              asin: "8086217868",
              marketplaceId: Marketplace.id("UK"),
              includedData: ["featuredBuyingOptions", "referencePrices", "lowestPricedOffers"],
            },
            {
              uri: "/products/pricing/2022-05-01/items/competitiveSummary",
              method: "GET",
              asin: "3822843865",
              marketplaceId: Marketplace.id("UK"),
              includedData: ["featuredBuyingOptions", "referencePrices", "lowestPricedOffers"],
            },
            {
              uri: "/products/pricing/2022-05-01/items/competitiveSummary",
              method: "GET",
              asin: "B003EHOCGE",
              marketplaceId: Marketplace.id("UK"),
              includedData: ["featuredBuyingOptions", "referencePrices", "lowestPricedOffers"],
            },
          ],
        }
        res = api.get_competitive_summary(batch)

        assert_predicate(res.status, :ok?)
      end
    end
  end
end
