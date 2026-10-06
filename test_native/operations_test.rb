# frozen_string_literal: true

require_relative "test_helper"

# Protocol and lifecycle tests assert several parts of one interaction.
# rubocop:disable Minitest/MultipleAssertions
class OperationsTest < NativeTest
  INVENTORY = JSON.parse(File.read(File.expand_path("../crates/peddler-codegen/operation-inventory.json", __dir__)))
    .fetch("apis").flat_map { |api| api.fetch("operations") }.to_h { |operation| [operation.fetch("key"), operation.fetch("parameters")] }

  def test_explicit_null_omits_optional_array_and_catalog_locale_is_encoded
    serve(handler: lambda { |socket, first, *|
      assert_equal("/catalog/2022-04-01/items/%252F", first[1].split("?", 2)[0])
      assert_equal([["locale", "en&GB"], ["marketplaceIds", "UK"]], URI.decode_www_form(first[1].split("?", 2)[1]).sort)
      respond(socket)
    }) do |url|
      assert_equal(200, client(url).catalog_items_2022_04_01
        .get_catalog_item("%2F", ["UK"], included_data: nil, locale: "en&GB").status)
    end
  end

  # An empty argument is refused only where it ends the path, since it would reach the parent collection.
  def test_named_methods_reject_bad_path_segments_and_wrong_types
    instance = client("http://127.0.0.1:1")
    [[".", ["UK"]], ["..", ["UK"]], ["", ["UK"]], ["X", [1]], ["X", "private"]].each do |asin, marketplace_ids|
      error = assert_raises(ArgumentError) { instance.catalog_items_2022_04_01.get_catalog_item(asin, marketplace_ids) }

      assert_equal("invalid request", error.message)
    end
    [["..", "X"], ["S", "."], ["S", ""]].each do |seller_id, sku|
      error = assert_raises(ArgumentError) do
        instance.listings_items_2021_08_01.patch_listings_item(seller_id, sku, ["UK"], {})
      end

      assert_equal("invalid request", error.message)
    end
  end

  # The shared cases name arguments as the Rust core does. A method takes the required ones in the spec's order
  # and a body under the name the spec gives it.
  def call(api, key, arguments)
    method = api.method(key.split(".", 2).last)
    named = INVENTORY.fetch(key).reject { |parameter| parameter["in"] == "body" }.map { |parameter| parameter["name"] }
    positional = []
    keywords = {}
    method.parameters.each do |kind, name|
      argument = named.include?(name.to_s) ? name.to_s : "body"
      next unless arguments.key?(argument)

      kind == :req ? positional << arguments[argument] : keywords[name] = arguments[argument]
    end
    method.call(*positional, **keywords)
  end

  def test_all_generated_facades_replay_shared_protocol_cases
    cases = JSON.parse(File.read(File.expand_path("../test/fixtures/native/operations/full_cases.json", __dir__)))
    cases.each do |example|
      serve(handler: lambda { |socket, first, headers, body|
        assert_equal(example.fetch("method"), first[0])
        assert_equal(example.fetch("path"), first[1].split("?", 2)[0])
        assert_equal(example.fetch("query").sort, URI.decode_www_form(first[1].split("?", 2)[1] || "").sort)
        example.fetch("headers", []).each { |name, value| assert_equal(value, headers[name]) }
        assert_match(AMZ_DATE, headers["x-amz-date"])
        if example["body"].nil?
          assert_empty(body)
          refute_equal("application/json", headers["content-type"])
        else
          assert_equal(example.fetch("body"), JSON.parse(body))
        end
        respond(socket, status: example.fetch("status"), headers: [["x-repeat", "first"], ["x-repeat", "second"]],
          body: example.fetch("response"))
      }) do |url|
        key = example.fetch("operation")
        call = -> { call(client(url).public_send(key.split(".", 2).first), key, example.fetch("arguments")) }
        response = example.fetch("status") < 400 ? call.call : assert_raises(Peddler::Error, &call).response

        assert_equal(example.fetch("status"), response.status)
        assert_equal(example.fetch("response"), response.body)
        assert_equal(2, response.headers.count { |name, _value| name == "x-repeat" })
        if response.status >= 400
          error = assert_raises(Peddler::Error) { response.raise_for_status! }
          assert_same(response, error.response)
        end
      end
    end
  end

  def test_latest_aliases_are_available
    assert_instance_of(Peddler::Native::ShippingV2, client("http://127.0.0.1:1").shipping)
    assert_instance_of(Peddler::Native::CatalogItems20220401, client("http://127.0.0.1:1").catalog_items)
    assert_instance_of(Peddler::Native::SellersV1, client("http://127.0.0.1:1").sellers)
  end
end
# rubocop:enable Minitest/MultipleAssertions
