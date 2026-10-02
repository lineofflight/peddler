# frozen_string_literal: true

require "helper"

module Peddler
  module APIs
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

        res = api.put_listings_item(seller_id: "A34PPN1ZLYCOGT", sku: "SKU123", marketplace_ids: Marketplace.ids("UK"), body: body)

        assert_equal(200, res.status)
        assert_success(res)
      end

      def test_patch_listings_item
        body = {
          productType: "PRODUCT",
          patches: [
            {
              op: "replace",
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

        res = api.patch_listings_item(seller_id: "A34PPN1ZLYCOGT", sku: "SKU123", marketplace_ids: Marketplace.ids("UK"), body: body)

        assert_equal(200, res.status)
        assert_success(res)
      end

      def test_get_listings_item
        res = api.get_listings_item(
          seller_id: "A34PPN1ZLYCOGT",
          sku: "SKU123",
          marketplace_ids: Marketplace.ids("UK"),
          included_data: ["attributes", "issues"],
        )

        assert_equal(200, res.status)
        assert_success(res)
      end

      def test_delete_listings_item
        res = api.delete_listings_item(seller_id: "A34PPN1ZLYCOGT", sku: "SKU123", marketplace_ids: Marketplace.ids("UK"))

        assert_equal(200, res.status)
        assert_success(res)
      end
    end
  end
end
