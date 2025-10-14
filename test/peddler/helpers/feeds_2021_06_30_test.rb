# frozen_string_literal: true

require "helper"

module Peddler
  module Helpers
    class Feeds20210630Test < Minitest::Test
      extend Forwardable
      include FeatureHelpers
      include Feeds20210630

      def_delegators :api, :parser

      def test_upload_feed_document
        url = "https://tortuga-prod-eu.s3-eu-west-1.amazonaws.com/123456"

        content = {
          "header": {
            "sellerId": "A34PPN1ZLYCOGT",
            "version": "2.0",
            "issueLocale": "en_US",
          },
          "messages": [
            {
              "messageId": 1,
              "sku": "SKU123",
              "operationType": "UPDATE",
              "productType": "PRODUCT",
              "requirements": "LISTING_OFFER_ONLY",
              "attributes": {
                "merchant_suggested_asin": [{
                  "value": "188864544X",
                  "marketplace_id": Marketplace.id("UK"),
                }],
                "condition_type": [{
                  "value": "new_new",
                  "marketplace_id": Marketplace.id("UK"),
                }],
                "merchant_shipping_group": [
                  {
                    "value": "legacy-template-id",
                    "marketplace_id": Marketplace.id("UK"),
                  },
                ],
                "fulfillment_availability": [{
                  "fulfillment_channel_code": "DEFAULT",
                  "quantity": 1,
                  "lead_time_to_ship_max_days": 3,
                }],
                "purchasable_offer": [{
                  "currency": "GBP",
                  "our_price": [{
                    "schedule": [{
                      "value_with_tax": 400,
                    }],
                  }],
                  "minimum_seller_allowed_price": [{
                    "schedule": [{
                      "value_with_tax": 350,
                    }],
                  }],
                  "maximum_seller_allowed_price": [{
                    "schedule": [{
                      "value_with_tax": 450,
                    }],
                  }],
                  "marketplace_id": Marketplace.id("UK"),
                }],
              },
            },
          ],
        }
        res = upload_feed_document(url, JSON.generate(content), "application/json; charset=UTF-8")

        assert_predicate(res.status, :success?)
      end

      def test_download_result_feed_document
        url = "https://tortuga-prod-eu.s3-eu-west-1.amazonaws.com/321"
        res = download_result_feed_document(url)

        assert_predicate(res.status, :success?)
        assert(res.body)
      end
    end
  end
end
