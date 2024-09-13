# frozen_string_literal: true

require "helper"

require "peddler/api/listings_items_2021_08_01"

module Peddler
  class API
    class ListingsItems20210801Test < Minitest::Test
      def setup
        super
        @api = ListingsItems20210801.new(aws_region, request_access_token)
      end

      def test_put_listings_item
        body = {
          productType: "PRODUCT",
          requirements: "LISTING_OFFER_ONLY",
          attributes: {
            merchant_suggested_asin: [{
              value: "188864544X",
              marketplace_id: "A1F83G8C2ARO7P",
            }],
            condition_type: [{
              value: "new_new",
              marketplace_id: "A1F83G8C2ARO7P",
            }],
            merchant_shipping_group: [
              {
                value: "legacy-template-id",
                marketplace_id: "A1F83G8C2ARO7P",
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
              marketplace_id: "A1F83G8C2ARO7P",
            }],
          },
        }

        res = @api.put_listings_item("A34PPN1ZLYCOGT", "SKU123", "A1F83G8C2ARO7P", body)

        assert_predicate(res.status, :ok?)
      end

      def test_get_listings_item
        res = @api.get_listings_item(
          "A34PPN1ZLYCOGT",
          "SKU123",
          "A1F83G8C2ARO7P",
          included_data: "attributes,issues",
        )

        assert_predicate(res.status, :ok?)
      end

      def test_delete_listings_item
        res = @api.delete_listings_item("A34PPN1ZLYCOGT", "SKU123", "A1F83G8C2ARO7P")

        assert_predicate(res.status, :ok?)
      end
    end
  end
end
