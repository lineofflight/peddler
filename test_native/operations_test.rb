# frozen_string_literal: true

require_relative "test_helper"

# Protocol and lifecycle tests assert several parts of one interaction.
# rubocop:disable Minitest/MultipleAssertions
class OperationsTest < NativeTest
  APIS = JSON.parse(File.read(File.expand_path("../crates/peddler-codegen/operation-inventory.json", __dir__))).fetch("apis")
  INVENTORY = APIS.flat_map { |api| api.fetch("operations") }.to_h { |operation| [operation.fetch("key"), operation.fetch("parameters")] }

  # Stands in for the engine: keeps the operation and the rate of each call, and answers with the next body.
  class Recorder
    attr_reader :calls

    def initialize(*bodies)
      @bodies = bodies
      @calls = []
    end

    def operation(name, _arguments, rate_limit)
      @calls << [name, rate_limit]
      [200, [], @bodies.shift || "{}", nil]
    end
  end

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
  def test_named_methods_reject_dot_and_empty_last_path_segments_by_name
    instance = client("http://127.0.0.1:1")
    { "." => "asin must not be . or ..", ".." => "asin must not be . or ..", "" => "asin must not be empty" }.each do |asin, message|
      error = assert_raises(ArgumentError) { instance.catalog_items_2022_04_01.get_catalog_item(asin, ["UK"]) }

      assert_equal(message, error.message)
    end
    {
      ["..", "X"] => "seller_id must not be . or ..",
      ["S", "."] => "sku must not be . or ..",
      ["S", ""] => "sku must not be empty",
    }.each do |(seller_id, sku), message|
      error = assert_raises(ArgumentError) do
        instance.listings_items_2021_08_01.patch_listings_item(seller_id, sku, ["UK"], {})
      end

      assert_equal(message, error.message)
    end
    error = assert_raises(ArgumentError) { instance.finances_v0.list_financial_events_by_group_id_pages("..").first }

    assert_equal("event_group_id must not be . or ..", error.message)
  end

  # What an argument's coercion takes, by the type the spec gives it. A body has none.
  def sample(parameter)
    case parameter&.dig("schema", "type")
    when nil then {}
    when "array" then ["x"]
    when "boolean" then true
    when "integer", "number" then 1
    else "x"
    end
  end

  # v5 took rate_limit: last, and its default was the rate Amazon documents. Every operation takes it so, and
  # its *_pages twin, also where Amazon documents no rate and the default is nil.
  def test_every_operation_takes_rate_limit_last_and_its_default_is_the_documented_rate
    engine = Recorder.new
    APIS.each do |api|
      facade = Peddler::Native.const_get(api.fetch("ruby_class")).new(engine)
      api.fetch("operations").each do |operation|
        key = operation.fetch("key")
        name = key.split(".", 2).last
        calls = [facade.method(name)]
        parameters = calls.first.parameters

        assert_equal([:key, :rate_limit], parameters.last, key)
        if operation["pagination"]
          pages = facade.method("#{name}_pages")

          assert_equal(parameters, pages.parameters, key)
          calls << ->(*arguments, **keywords) { pages.call(*arguments, **keywords).first }
        end
        named = operation.fetch("parameters").reject { |parameter| parameter["in"] == "body" }
        required = parameters.select { |kind, _| kind == :req }.map do |_, argument|
          sample(named.find { |parameter| parameter["name"] == argument.to_s })
        end
        calls.each do |call|
          { {} => operation["rate"], { rate_limit: 100 } => 100.0, { rate_limit: nil } => nil }.each do |given, rate|
            call.call(*required, **given)

            assert_equal([[key, rate]], engine.calls.slice!(0..), "#{key} #{given}")
          end
        end
      end
    end
  end

  # The operation and the rate of each call the engine gets for 2 pages
  def paged(api, name, first_page, *arguments, **keywords)
    engine = Recorder.new(first_page)

    assert_equal(2, Peddler::Native.const_get(api).new(engine).public_send(name, *arguments, **keywords).to_a.size)
    engine.calls
  end

  def test_every_page_is_requested_at_the_rate_given
    orders = ->(**given) { paged(:OrdersV0, :get_orders_pages, '{"payload":{"NextToken":"A"}}', ["UK"], **given) }
    # The pages of feeds after the first are another operation of the core.
    feeds = ->(**given) { paged(:Feeds20210630, :get_feeds_pages, '{"nextToken":"A"}', **given) }
    documented = APIS.flat_map { |api| api.fetch("operations") }.to_h { |operation| [operation["key"], operation["rate"]] }

    assert_equal([["orders_v0.get_orders", documented.fetch("orders_v0.get_orders")]] * 2, orders.call)
    assert_equal([["orders_v0.get_orders", 2.0]] * 2, orders.call(rate_limit: 2))
    assert_equal([["orders_v0.get_orders", nil]] * 2, orders.call(rate_limit: nil))
    [[{}, documented.fetch("feeds_2021_06_30.get_feeds")], [{ rate_limit: 0.5 }, 0.5]].each do |given, rate|
      assert_equal([["feeds_2021_06_30.get_feeds", rate], ["feeds_2021_06_30.get_feeds.continue", rate]], feeds.call(**given))
    end
  end

  # The core refuses such a rate too, should anything call the engine without the argument's check.
  def test_the_engine_refuses_a_rate_that_is_not_positive_and_finite
    serve_keep_alive do |url, _accepted, requests|
      engine = client(url).instance_variable_get(:@engine)
      [0.0, -1.0, Float::NAN, Float::INFINITY].each do |rate|
        error = assert_raises(ArgumentError) { engine.operation("sellers_v1.get_marketplace_participations", "{}", rate) }

        assert_equal("invalid request", error.message)
      end
      assert_empty(requests)
      assert_equal(200, engine.operation("sellers_v1.get_marketplace_participations", "{}", nil).first)
      assert_equal(1, requests.size)
    end
  end

  # The shared cases name arguments as the Rust core does. A method takes the required ones in the spec's order
  # and a body under the name the spec gives it. Its last keyword is the rate, which is no argument of the core.
  def call(api, key, arguments)
    method = api.method(key.split(".", 2).last)
    named = INVENTORY.fetch(key).reject { |parameter| parameter["in"] == "body" }.map { |parameter| parameter["name"] }
    positional = []
    keywords = {}
    method.parameters.each do |kind, name|
      next if name == :rate_limit

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

  # The models of an API are named through Peddler's inflector, with Peddler's acronyms. The generator of the API's
  # class keeps a list of them of its own.
  def test_an_apis_class_is_named_as_its_models_are
    inflector = Peddler::Inflector.new(File.expand_path("../lib/peddler.rb", __dir__))
    APIS.each do |api|
      name = api.fetch("ruby_class")

      assert_equal(Peddler::Acronyms.apply(name), name)
      assert_equal(inflector.camelize(api.fetch("module"), ""), name)
    end
    assert_instance_of(Peddler::Native::FBAInventoryV1, client("http://127.0.0.1:1").fba_inventory_v1)
  end

  # An API's class is an Object, and an operation named `class`, `send` or `freeze` would replace the method every
  # Object has. `initialize` is the constructor the generator writes.
  def test_no_generated_method_replaces_a_method_of_object
    taken = Object.instance_methods + Object.private_instance_methods - [:initialize]
    replaced = APIS.flat_map do |api|
      view = Peddler::Native.const_get(api.fetch("ruby_class"))
      ((view.instance_methods(false) + view.private_instance_methods(false)) & taken).map { |name| "#{view}##{name}" }
    end

    assert_empty(replaced)
  end
end
# rubocop:enable Minitest/MultipleAssertions
