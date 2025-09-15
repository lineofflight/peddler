# frozen_string_literal: true

require "helper"
require "peddler/apis/product_pricing_v0"

module Peddler
  module APIs
    class ProductPricingV0Test < Minitest::Test
      include FeatureHelpers

      def test_get_pricing
        res = api.sandbox.get_pricing("ATVPDKIKX0DER", "Asin")

        assert_predicate(res.status, :success?)
      end

      def test_get_competitive_pricing
        res = api.sandbox.get_competitive_pricing("ATVPDKIKX0DER", "Asin")

        assert_predicate(res.status, :success?)
      end

      def test_get_listing_offers
        res = api.sandbox.get_listing_offers("ATVPDKIKX0DER", "New", "NABetaASINB00V5DG6IQ")

        assert_predicate(res.status, :success?)
      end

      def test_get_item_offers
        res = api.sandbox.get_item_offers("ATVPDKIKX0DER", "New", "B00V5DG6IQ")

        assert_predicate(res.status, :success?)
      end

      def test_get_item_offers_batch
        payload = {
          requests: [
            {
              uri: "/products/pricing/v0/items/B000P6Q7MY/offers",
              method: "GET",
              MarketplaceId: "ATVPDKIKX0DER",
              ItemCondition: "New",
              CustomerType: "Consumer",
            },
            {
              uri: "/products/pricing/v0/items/B001Q3KU9Q/offers",
              method: "GET",
              MarketplaceId: "ATVPDKIKX0DER",
              ItemCondition: "New",
              CustomerType: "Consumer",
            },
            {
              uri: "/products/pricing/v0/items/B007Z07UK6/offers",
              method: "GET",
              MarketplaceId: "ATVPDKIKX0DER",
              ItemCondition: "New",
              CustomerType: "Consumer",
            },
            {
              uri: "/products/pricing/v0/items/B000OQA3N4/offers",
              method: "GET",
              MarketplaceId: "ATVPDKIKX0DER",
              ItemCondition: "New",
              CustomerType: "Consumer",
            },
            {
              uri: "/products/pricing/v0/items/B07PTMKYS7/offers",
              method: "GET",
              MarketplaceId: "ATVPDKIKX0DER",
              ItemCondition: "New",
              CustomerType: "Consumer",
            },
            {
              uri: "/products/pricing/v0/items/B001PYUTII/offers",
              method: "GET",
              MarketplaceId: "ATVPDKIKX0DER",
              ItemCondition: "New",
              CustomerType: "Consumer",
            },
            {
              uri: "/products/pricing/v0/items/B00505DW2I/offers",
              method: "GET",
              MarketplaceId: "ATVPDKIKX0DER",
              ItemCondition: "New",
              CustomerType: "Consumer",
            },
            {
              uri: "/products/pricing/v0/items/B00CGZQU42/offers",
              method: "GET",
              MarketplaceId: "ATVPDKIKX0DER",
              ItemCondition: "New",
              CustomerType: "Consumer",
            },
            {
              uri: "/products/pricing/v0/items/B01LY2ZYRF/offers",
              method: "GET",
              MarketplaceId: "ATVPDKIKX0DER",
              ItemCondition: "New",
              CustomerType: "Consumer",
            },
            {
              uri: "/products/pricing/v0/items/B00KFRNZY6/offers",
              method: "GET",
              MarketplaceId: "ATVPDKIKX0DER",
              ItemCondition: "New",
              CustomerType: "Consumer",
            },
          ],
        }
        res = api.sandbox.get_item_offers_batch(payload)

        assert_predicate(res.status, :success?)
      end

      def test_get_listing_offers_batch
        payload = {
          requests: [
            {
              uri: "/products/pricing/v0/listings/GC-QTMS-SV2I/offers",
              method: "GET",
              MarketplaceId: "ATVPDKIKX0DER",
              ItemCondition: "New",
              CustomerType: "Consumer",
            },
            {
              uri: "/products/pricing/v0/listings/VT-DEIT-57TQ/offers",
              method: "GET",
              MarketplaceId: "ATVPDKIKX0DER",
              ItemCondition: "New",
              CustomerType: "Consumer",
            },
            {
              uri: "/products/pricing/v0/listings/NA-H7X1-JYTM/offers",
              method: "GET",
              MarketplaceId: "ATVPDKIKX0DER",
              ItemCondition: "New",
              CustomerType: "Consumer",
            },
            {
              uri: "/products/pricing/v0/listings/RL-JVOC-MBSL/offers",
              method: "GET",
              MarketplaceId: "ATVPDKIKX0DER",
              ItemCondition: "New",
              CustomerType: "Consumer",
            },
            {
              uri: "/products/pricing/v0/listings/74-64KG-H9W9/offers",
              method: "GET",
              MarketplaceId: "ATVPDKIKX0DER",
              ItemCondition: "New",
              CustomerType: "Consumer",
            },
          ],
        }
        res = api.sandbox.get_listing_offers_batch(payload)

        assert_predicate(res.status, :success?)
      end
    end
  end
end
