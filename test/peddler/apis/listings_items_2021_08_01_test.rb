# frozen_string_literal: true

require "helper"

require "peddler/apis/listings_items_2021_08_01"

module Peddler
  class API
    class ListingsItems20210801Test < Minitest::Test
      include FeatureHelpers

      def test_put_listings_item
        body = {
          productType: "PRODUCT",
          requirements: "LISTING_OFFER_ONLY",
          attributes: {
            merchant_suggested_asin: [{
              value: "188864544X",
              marketplace_id: Marketplace.id("UK"),
            }],
            condition_type: [{
              value: "new_new",
              marketplace_id: Marketplace.id("UK"),
            }],
            merchant_shipping_group: [
              {
                value: "legacy-template-id",
                marketplace_id: Marketplace.id("UK"),
              },
            ],
            fulfillment_availability: [{
              fulfillment_channel_code: "DEFAULT",
              quantity: 1,
              lead_time_to_ship_max_days: 3,
            }],
            purchasable_offer: [{
              currency: "GBP",
              our_price: [{
                schedule: [{
                  value_with_tax: 400,
                }],
              }],
              minimum_seller_allowed_price: [{
                schedule: [{
                  value_with_tax: 350,
                }],
              }],
              maximum_seller_allowed_price: [{
                schedule: [{
                  value_with_tax: 450,
                }],
              }],
              marketplace_id: Marketplace.id("UK"),
            }],
          },
        }

        res = api.put_listings_item("A34PPN1ZLYCOGT", "SKU123", Marketplace.id("UK"), body)

        assert_predicate(res.status, :ok?)
      end

      def test_patch_listings_item
        body = {
          productType: "PRODUCT",
          patches: [
            {
              op: 1,
              path: "/attributes/purchasable_offer",
              value: [{
                currency: "GBP",
                our_price: [{
                  schedule: [{
                    value_with_tax: 399.99,
                  }],
                }],
              }],
            },
          ],
        }

        res = api.patch_listings_item("A34PPN1ZLYCOGT", "SKU123", Marketplace.id("UK"), body)

        assert_predicate(res.status, :ok?)
      end

      def test_get_listings_item
        res = api.get_listings_item(
          "A34PPN1ZLYCOGT",
          "SKU123",
          Marketplace.id("UK"),
          included_data: "attributes,issues",
        )

        assert_predicate(res.status, :ok?)
      end

      def test_delete_listings_item
        res = api.delete_listings_item("A34PPN1ZLYCOGT", "SKU123", Marketplace.id("UK"))

        assert_predicate(res.status, :ok?)
      end
    end
  end
end
