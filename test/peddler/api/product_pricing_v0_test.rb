# frozen_string_literal: true

require "helper"

require "peddler/api/product_pricing_v0"

module Peddler
  class API
    class ProductPricingV0Test < Minitest::Test
      def setup
        super
        @api = ProductPricingV0.new(aws_region, request_access_token)
      end

      def test_get_pricing
        res = @api.get_pricing("A1F83G8C2ARO7P", "Asin", asins: ["188864544X"])

        assert_predicate(res.status, :ok?)
      end

      def test_get_competitive_pricing
        res = @api.get_competitive_pricing("A1F83G8C2ARO7P", "Asin", asins: ["188864544X"])

        assert_predicate(res.status, :ok?)
      end

      def test_get_item_offers
        res = @api.get_item_offers("A1F83G8C2ARO7P", "New", "B0CHXFCYCR")

        assert_predicate(res.status, :ok?)
      end

      def test_get_item_offers_batch
        request_batch = {
          "requests" => [
            {
              "uri" => "/products/pricing/v0/items/B0CHXFCYCR/offers",
              "method" => "GET",
              "MarketplaceId" => "A1F83G8C2ARO7P",
              "ItemCondition" => "New",
            },
            {
              "uri" => "/products/pricing/v0/items/B0CHXFCYCR/offers",
              "method" => "GET",
              "MarketplaceId" => "A1F83G8C2ARO7P",
              "ItemCondition" => "Used",
            },

          ],
        }
        res = @api.get_item_offers_batch(request_batch)

        assert_predicate(res.status, :ok?)
      end
    end
  end
end
