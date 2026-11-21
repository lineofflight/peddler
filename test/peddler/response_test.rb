# frozen_string_literal: true

require "helper"

# A response is asserted through its readers together.
# rubocop:disable Minitest/MultipleAssertions
module Peddler
  class ResponseTest < Minitest::Test
    def test_to_h
      response = Response.new(200, [], JSON.generate(payload))

      assert_equal(payload, response.to_h)
      assert_same(response.to_h, response.to_h)
    end

    def test_dig
      response = Response.new(200, [], JSON.generate(payload))

      assert_equal("itemName", response.dig("summaries", 0, "itemName"))
      assert_nil(response.dig("summaries", 1, "itemName"))
    end

    # The readers v5 code used, when a response delegated to the http gem's.

    def test_to_s_is_the_body_in_the_charset_of_the_content_type
      report = Response.new(200, [["content-type", "text/plain; charset=Cp1252"]], "caf\xE9\t\x805".b)

      assert_equal("café\t€5", report.to_s.encode("UTF-8"))
      assert_equal(Encoding::BINARY, report.body.encoding)
      assert_equal(payload, JSON.parse(Response.new(200, [], JSON.generate(payload)).to_s))
      # JSON without a charset read as UTF-8, and an unknown or missing charset as binary.
      assert_equal(Encoding::UTF_8, Response.new(200, [["content-type", "application/json"]], "{}".b).to_s.encoding)
      assert_equal(Encoding::BINARY, Response.new(200, [["content-type", "text/plain; charset=bogus"]], "x").to_s.encoding)
      assert_equal(Encoding::BINARY, Response.new(200, [], "x").to_s.encoding)
    end

    # A response is its body wherever a String is taken, as in JSON.parse(response).
    def test_to_str_is_to_s
      response = Response.new(200, [["content-type", "application/json"]], JSON.generate(payload).b)

      assert_equal(payload, JSON.parse(response))
      assert_equal([response.to_s, Encoding::UTF_8], [response.to_str, response.to_str.encoding])
      assert_equal("body: {}", "body: " + Response.new(200, [], "{}"))
    end

    def test_charset_is_the_charset_of_the_content_type
      assert_equal("Cp1252", Response.new(200, [["content-type", "text/plain; charset=Cp1252"]], "").charset)
      assert_equal("utf-8", Response.new(200, [["content-type", 'application/json; Charset="utf-8"']], "").charset)
      assert_nil(Response.new(200, [["content-type", "text/plain"]], "").charset)
      assert_nil(Response.new(200, [], "").charset)
    end

    # A body can hold a token, as the response of create_restricted_data_token does.
    def test_inspect_shows_the_class_and_the_status_only
      response = Response.new(200, [["x-amzn-requestid", "dummy-header"]], '{"restrictedDataToken":"dummy-token"}')

      assert_equal("#<Peddler::Response 200>", response.inspect)
      assert_equal("#<Peddler::Response 200>", Error.new("no", response).response.inspect)
    end

    def test_code_is_the_integer_status
      assert_same(404, Response.new(404, [], "").code)
    end

    def test_status_answers_the_predicates_and_behaves_as_the_integer
      status = Response.new(200, [], "").status

      assert_predicate(status, :success?)
      refute_predicate(status, :client_error?)
      # Equal from either side: 200 == status, then status == 200.
      assert_equal(200, status)
      assert_includes([status], 200)
      assert_operator(status, :<, 300)
      assert_equal(0, status <=> 200)
      assert_includes(200..299, status)
      assert_equal(:ok, case status when 200..299 then :ok end)
      assert_equal([200, "OK", 200, "200"], [status.code, status.reason, status.to_i, status.inspect])
      { 100 => :informational?, 302 => :redirect?, 404 => :client_error?, 503 => :server_error? }.each do |code, predicate|
        assert_predicate(Response.new(code, [], "").status, predicate)
      end
      assert_equal("Not Found", Response.new(404, [], "").status.reason)
    end

    def test_headers_look_up_a_name_in_any_case
      pairs = [["content-type", "text/plain"], ["x-repeat", "a"], ["x-repeat", "b"]]
      headers = Response.new(200, pairs, "").headers

      assert_equal("text/plain", headers["Content-Type"])
      assert_equal(["a", "b"], headers["X-Repeat"])
      assert_nil(headers["Missing"])
      assert_equal({ "content-type" => "text/plain", "x-repeat" => ["a", "b"] }, headers.to_h)
      assert_equal(pairs, headers.each.to_a)
    end

    # As v5's headers answered them: by name, not by pair.
    def test_headers_answer_whether_they_have_a_name_in_any_case
      headers = Response.new(200, [["content-type", "text/plain"]], "").headers

      ["Content-Type", "content-type", :"CONTENT-TYPE"].each do |name|
        assert_includes(headers, name)
        assert(headers.key?(name))
      end
      refute_includes(headers, "Missing")
      refute(headers.key?("text/plain"))
    end

    def test_to_h_raises_on_a_body_that_is_not_json
      assert_raises(JSON::ParserError) { Response.new(204, [], "").to_h }
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

    def test_a_blank_message_from_amazon_falls_back_to_the_status
      ["", " \n"].each do |blank|
        error = assert_raises(Error) { Response.new(400, [], "", ["InvalidInput", "request-id", blank]).raise_for_status! }

        assert_equal(["request failed with status 400", "InvalidInput", "request-id"], [error.message, error.code, error.request_id])
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
