# frozen_string_literal: true

require "helper"

# A response is asserted through its readers together.
# rubocop:disable Minitest/MultipleAssertions
module Peddler
  class ResponseTest < Minitest::Test
    def test_json
      response = Response.new(200, [], JSON.generate(payload))

      assert_equal(payload, response.json)
      assert_same(response.json, response.json)
    end

    def test_to_h
      assert_equal(payload, Response.new(200, [], JSON.generate(payload)).to_h)
    end

    def test_dig
      response = Response.new(200, [], JSON.generate(payload))

      assert_equal("itemName", response.dig("summaries", 0, "itemName"))
      assert_nil(response.dig("summaries", 1, "itemName"))
    end

    def test_json_raises_on_a_body_that_is_not_json
      assert_raises(JSON::ParserError) { Response.new(204, [], "").json }
    end

    def test_parse_returns_the_typed_model_of_the_operation
      response = Response.new(200, [], JSON.generate(payload), nil, operation: "catalog_items_2022_04_01.get_catalog_item")
      item = response.parse

      assert_instance_of(APIs::CatalogItems20220401::Item, item)
      assert_equal("188864544X", item.asin)
      assert_equal("itemName", item.summaries.first.item_name)
    end

    def test_parse_returns_the_hash_without_a_typed_model
      body = JSON.generate(payload)

      assert_equal(payload, Response.new(200, [], body).parse)
      assert_equal(payload, Response.new(200, [], body, nil, operation: "raw").parse)
      assert_equal(payload, Response.new(200, [], body, nil, operation: "orders_v0.confirm_shipment").parse)
      assert_equal(payload, Response.new(200, [], body, nil, operation: "unknown_api.unknown").parse)
    end

    def test_parse_returns_the_hash_of_an_error_response
      body = '{"errors":[{"code":"NotFound","message":"Item not found"}]}'
      response = Response.new(404, [], body, ["NotFound", nil, "Item not found"], operation: "catalog_items_2022_04_01.get_catalog_item")
      error = assert_raises(Error) { response.raise_for_status! }

      assert_equal(JSON.parse(body), error.response.parse)
      assert_equal("NotFound", error.response.parse.dig("errors", 0, "code"))
    end

    def test_parse_maps_camel_case_keys_to_snake_case_attributes
      body = '{"feedId":"50029018011","feedType":"POST_PRODUCT_DATA","createdTime":"2024-03-11T13:16:24.630Z","processingStatus":"DONE"}'
      feed = Response.new(200, [], body, nil, operation: "feeds_2021_06_30.get_feed").parse

      assert_instance_of(APIs::Feeds20210630::Feed, feed)
      assert_equal("50029018011", feed.feed_id)
      assert_equal(Time.parse("2024-03-11T13:16:24.630Z"), feed.created_time)
    end

    def test_raise_for_status_returns_self_on_success
      [200, 201, 204, 207, 299].each do |status|
        response = Response.new(status, [], "")

        assert_same(response, response.raise_for_status!)
      end
    end

    def test_raise_for_status_raises_outside_2xx
      [400, 404, 429, 500, 503].each do |status|
        response = Response.new(status, [], "")
        error = assert_raises(Error) { response.raise_for_status! }

        assert_same(response, error.response)
        assert_equal(status, error.status)
      end
    end

    def test_a_hand_built_error_response_raises_and_parses_to_the_hash
      body = '{"errors":[{"code":"NotFound","message":"Item not found"}]}'
      response = Response.new(404, [], body, operation: "catalog_items_2022_04_01.get_catalog_item")
      error = assert_raises(Error) { response.raise_for_status! }

      assert_same(response, error.response)
      assert_equal(["request failed with status 404", nil, nil], [error.message, error.code, error.request_id])
      assert_equal(JSON.parse(body), response.parse)
    end

    private

    def payload
      { "asin" => "188864544X", "summaries" => [{ "marketplaceId" => "A1F83G8C2ARO7P", "itemName" => "itemName" }] }
    end
  end
end
# rubocop:enable Minitest/MultipleAssertions
