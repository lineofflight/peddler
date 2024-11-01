# frozen_string_literal: true

require "helper"

require "peddler/apis/feeds_2021_06_30"

module Peddler
  module APIs
    class Feeds20210630Test < Minitest::Test
      include FeatureHelpers

      def test_create_feed_document
        res = api.create_feed_document(
          { "contentType" => "application/json; charset=UTF-8" },
        )

        assert_predicate(res.status, :created?)
      end

      def test_create_feed
        feed_document_id = "amzn1.tortuga.4.eu.123"
        url = "https://tortuga-prod-eu.s3-eu-west-1.amazonaws.com/123"

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
        res = api.upload_feed_document(url, JSON.generate(content), "application/json; charset=UTF-8")

        assert_predicate(res.status, :ok?)

        payload = {
          "feedType" => "JSON_LISTINGS_FEED",
          "marketplaceIds" => Marketplace.ids("UK"),
          "inputFeedDocumentId" => feed_document_id,
        }
        res = api.create_feed(payload)

        assert_predicate(res.status, :accepted?)
      end

      def test_get_feed
        feed_id = "123"
        res = api.get_feed(feed_id)

        assert_predicate(res.status, :ok?)
      end

      def test_get_feed_document
        feed_document_id = "amzn1.tortuga.4.eu.123"
        res = api.get_feed_document(feed_document_id)

        assert_predicate(res.status, :ok?)

        # Just exploring the result feed document
        url = res.dig("url")
        res = HTTP.get(url)
        body = Zlib::GzipReader.new(res).read

        assert(JSON.parse(body))
      end
    end
  end
end
