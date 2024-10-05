# frozen_string_literal: true

require "helper"

require "peddler/api/product_pricing_v0"

module Peddler
  class API
    class ProductPricingV0Test < Minitest::Test
      include FeatureHelpers

      def test_get_pricing
        res = api.get_pricing(Marketplace.id("UK"), "Asin", asins: ["188864544X"])

        assert_predicate(res.status, :ok?)
      end

      def test_get_competitive_pricing
        res = api.get_competitive_pricing(Marketplace.id("UK"), "Asin", asins: ["188864544X"])

        assert_predicate(res.status, :ok?)
      end

      def test_get_item_offers
        res = api.get_item_offers(Marketplace.id("UK"), "New", "B0CHXFCYCR")

        assert_predicate(res.status, :ok?)
      end

      def test_get_item_offers_batch
        batch = {
          "requests" => [
            {
              "uri" => "/products/pricing/v0/items/B0CHXFCYCR/offers",
              "method" => "GET",
              "MarketplaceId" => Marketplace.id("UK"),
              "ItemCondition" => "New",
            },
            {
              "uri" => "/products/pricing/v0/items/B0CHXFCYCR/offers",
              "method" => "GET",
              "MarketplaceId" => Marketplace.id("UK"),
              "ItemCondition" => "Used",
            },

          ],
        }
        res = api.get_item_offers_batch(batch)

        assert_predicate(res.status, :ok?)
      end
    end
  end
end
