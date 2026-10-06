# frozen_string_literal: true

require_relative "test_helper"

# Protocol and lifecycle tests assert several parts of one interaction.
# rubocop:disable Minitest/MultipleAssertions
class OperationsTest < NativeTest
  def test_explicit_null_omits_optional_array_and_catalog_locale_is_encoded
    serve(handler: lambda { |socket, first, *|
      assert_equal("/catalog/2022-04-01/items/%252F", first[1].split("?", 2)[0])
      assert_equal([["locale", "en&GB"], ["marketplaceIds", "UK"]], URI.decode_www_form(first[1].split("?", 2)[1]).sort)
      respond(socket)
    }) do |url|
      assert_equal(200, client(url).catalog_items_2022_04_01
        .get_catalog_item(asin: "%2F", marketplace_ids: ["UK"], included_data: nil, locale: "en&GB").status)
    end
  end

  # An empty argument is refused only where it ends the path, since it would reach the parent collection.
  def test_named_methods_reject_bad_path_segments_and_wrong_types
    instance = client("http://127.0.0.1:1")
    catalog_arguments = { asin: "X", marketplace_ids: ["UK"] }
    listings_arguments = { seller_id: "S", sku: "X", marketplace_ids: ["UK"], body: {} }
    [{ asin: "." }, { asin: ".." }, { asin: "" }, { marketplace_ids: [1] }, { marketplace_ids: "private" }].each do |invalid|
      error = assert_raises(ArgumentError) do
        instance.catalog_items_2022_04_01.get_catalog_item(**catalog_arguments.merge(invalid))
      end
      refute_match(/private/, error.message)
    end
    [{ seller_id: ".." }, { sku: "." }, { sku: "" }].each do |invalid|
      assert_raises(ArgumentError) do
        instance.listings_items_2021_08_01.patch_listings_item(**listings_arguments.merge(invalid))
      end
    end
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
        accessor, method = example.fetch("operation").split(".", 2)
        api = client(url).public_send(accessor)
        arguments = example.fetch("arguments").transform_keys(&:to_sym)
        call = -> { api.public_send(method, **arguments) }
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
