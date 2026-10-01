# frozen_string_literal: true

require_relative "test_helper"

# Protocol and lifecycle tests assert several parts of one interaction.
# rubocop:disable Minitest/MultipleAssertions
class OperationsTest < NativeTest
  CATALOG = "catalog_items_2022_04_01.get_catalog_item"
  LISTINGS = "listings_items_2021_08_01.patch_listings_item"

  def test_catalog_fixture_through_named_facade
    fixture = JSON.parse(File.read(File.expand_path("../test/fixtures/native/catalog_get.json", __dir__)))
    request = fixture.fetch("request")
    response = fixture.fetch("response")
    serve(handler: lambda { |socket, first, headers, body|
      assert_equal("GET", first[0])
      assert_equal(request["path"], first[1].split("?", 2)[0])
      assert_equal(request["query"].sort, URI.decode_www_form(first[1].split("?", 2)[1]).sort)
      assert_equal("local-secret", headers["x-amz-access-token"])
      assert_empty(body)
      respond(socket, status: response["status"], headers: response["headers"],
        body: Base64.strict_decode64(response["body_base64"]))
    }) do |url|
      result = client(url).catalog_items_2022_04_01.get_catalog_item(asin: "188864544X",
        marketplace_ids: ["A1F83G8C2ARO7P"],
        included_data: ["classifications", "dimensions", "identifiers", "images", "productTypes", "relationships", "salesRanks", "summaries"])

      assert_instance_of(Peddler::Native::Response, result)
      assert_equal(200, result.status)
      response["headers"].each { |pair| assert_includes(result.headers, pair) }
      assert_equal(Base64.strict_decode64(response["body_base64"]), result.body)
      assert_equal(Encoding::BINARY, result.body.encoding)
      assert_equal("188864544X", result.json["asin"])
      assert_same(result.json, result.json)
    end
  end

  def test_listings_fixture_through_named_facade
    fixture = JSON.parse(File.read(File.expand_path("../test/fixtures/native/listings_patch.json", __dir__)))
    request = fixture.fetch("request")
    response = fixture.fetch("response")
    serve(handler: lambda { |socket, first, headers, body|
      assert_equal("PATCH", first[0])
      assert_equal(request["path"], first[1].split("?", 2)[0])
      assert_equal(request["query"].sort, URI.decode_www_form(first[1].split("?", 2)[1]).sort)
      assert_equal("application/json", headers["content-type"])
      assert_equal(JSON.parse(Base64.strict_decode64(request["body_base64"])), JSON.parse(body))
      respond(socket, status: response["status"], headers: response["headers"],
        body: Base64.strict_decode64(response["body_base64"]))
    }) do |url|
      result = client(url).listings_items_2021_08_01.patch_listings_item(seller_id: "A34PPN1ZLYCOGT", sku: "SKU123",
        marketplace_ids: ["A1F83G8C2ARO7P"], body: JSON.parse(Base64.strict_decode64(request["body_base64"])))

      assert_equal(200, result.status)
      response["headers"].each { |pair| assert_includes(result.headers, pair) }
      assert_equal(Base64.strict_decode64(response["body_base64"]), result.body)
      assert_equal([], result.json["issues"])
    end
  end

  def test_catalog_defaults_csv_and_raw_segment_escaping
    serve(handler: lambda { |socket, first, _headers, _body|
      assert_equal("/catalog/2022-04-01/items/a%2Fb%20%2B%25%3F", first[1].split("?", 2)[0])
      assert_equal([["includedData", "summaries"], ["marketplaceIds", "UK,US"]],
        URI.decode_www_form(first[1].split("?", 2)[1]).sort)
      respond(socket)
    }) do |url|
      engine = Peddler::Native::Engine.new(url, "local-secret", 5)

      assert_equal(200, Peddler::Native::CatalogItems20220401.new(engine)
        .get_catalog_item(asin: "a/b +%?", marketplace_ids: ["UK", "US"]).status)
    end
  end

  def test_listings_unknown_query_values_and_dynamic_body_are_preserved
    payload = { "productType" => "future", "patches" => [], "unknown" => { "values" => [nil, true, 2, "é"] } }
    serve(handler: lambda { |socket, first, _headers, body|
      assert_equal("/listings/2021-08-01/items/s%2Feller/a%2Fb%20%2B%25%3F", first[1].split("?", 2)[0])
      assert_equal([["includedData", "issues,future"], ["issueLocale", "en&GB"], ["marketplaceIds", "UK,US"], ["mode", "future+mode"]],
        URI.decode_www_form(first[1].split("?", 2)[1]).sort)
      assert_equal(payload, JSON.parse(body))
      respond(socket)
    }) do |url|
      engine = Peddler::Native::Engine.new(url, "local-secret", 5)
      result = Peddler::Native::ListingsItems20210801.new(engine).patch_listings_item(seller_id: "s/eller", sku: "a/b +%?",
        marketplace_ids: ["UK", "US"], body: payload, included_data: ["issues", "future"], mode: "future+mode", issue_locale: "en&GB")

      assert_equal(200, result.status)
    end
  end

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

  def test_http_errors_binary_and_malformed_json_remain_raw
    fixture = JSON.parse(File.read(File.expand_path("../test/fixtures/native/not_found.json", __dir__))).fetch("response")
    [fixture, { "status" => 200, "headers" => [["x-repeat", "a"], ["x-repeat", "b"]], "body_base64" => Base64.strict_encode64("\xFF\x00{bad".b) },
      { "status" => 204, "headers" => [], "body_base64" => "" }].each do |response|
      serve(handler: ->(socket, *) { respond(socket, status: response["status"], headers: response["headers"], body: Base64.strict_decode64(response["body_base64"])) }) do |url|
        result = client(url).catalog_items_2022_04_01.get_catalog_item(asin: "X", marketplace_ids: ["UK"])

        assert_equal(response["status"], result.status)
        response["headers"].each { |pair| assert_includes(result.headers, pair) }
        assert_equal(Base64.strict_decode64(response["body_base64"]), result.body)
        assert_equal(Encoding::BINARY, result.body.encoding)
        if result.status == 404
          assert_equal("NotFound", result.json.fetch("errors")[0]["code"])
        else
          assert_raises(JSON::ParserError) { result.json }
        end
      end
    end
  end

  def test_invalid_operation_envelopes_are_redacted_before_network
    server = TCPServer.new("127.0.0.1", 0)
    engine = Peddler::Native::Engine.new("http://127.0.0.1:#{server.addr[1]}", "local-secret", 5)
    valid = { asin: "private", marketplace_ids: ["UK"] }
    [["unknown-private", "{}"], [CATALOG, "{private"], [CATALOG, JSON.generate(valid.merge(secret: "private"))],
      [CATALOG, JSON.generate(valid.merge(asin: nil))], [CATALOG, JSON.generate(valid.merge(marketplace_ids: "UK"))],
      [LISTINGS, JSON.generate(seller_id: "private", sku: "X", marketplace_ids: ["UK"], body: [])]].each do |operation, arguments|
      error = assert_raises(ArgumentError) { engine.operation(operation, arguments) }
      refute_match(/private|secret|127\.0\.0\.1/, error.message)
    end
    refute(server.wait_readable(0.05), "invalid operation reached the network")
  ensure
    server&.close
  end

  def test_named_methods_reject_invalid_paths_and_arrays
    instance = client("http://127.0.0.1:1")
    catalog_arguments = { asin: "X", marketplace_ids: ["UK"] }
    listings_arguments = { seller_id: "S", sku: "X", marketplace_ids: ["UK"], body: {} }
    [{ asin: "" }, { asin: "." }, { asin: ".." }, { marketplace_ids: [] }, { marketplace_ids: [""] },
      { marketplace_ids: ["private,US"] }, { marketplace_ids: [1] }, { included_data: [] }, { included_data: ["a,b"] }].each do |invalid|
      error = assert_raises(ArgumentError) do
        instance.catalog_items_2022_04_01.get_catalog_item(**catalog_arguments.merge(invalid))
      end
      refute_match(/private/, error.message)
    end
    [{ seller_id: ".." }, { sku: "" }, { marketplace_ids: [] }, { included_data: [""] }, { body: nil }, { body: "private" }].each do |invalid|
      assert_raises(ArgumentError) do
        instance.listings_items_2021_08_01.patch_listings_item(**listings_arguments.merge(invalid))
      end
    end
  end

  def test_operation_transport_errors_redact_arguments_and_origin
    server = TCPServer.new("127.0.0.1", 0)
    url = "http://127.0.0.1:#{server.addr[1]}"
    server.close
    error = assert_raises(Peddler::Native::TransportError) do
      client(url).listings_items_2021_08_01.patch_listings_item(seller_id: "private-seller", sku: "private-sku",
        marketplace_ids: ["UK"], body: { secret: "private-body" })
    end
    refute_match(/private|secret|127\.0\.0\.1|local-secret/, error.message)
  end

  def test_engine_operation_applies_defaults_to_omitted_arguments
    serve(handler: lambda { |socket, first, *|
      assert_equal([["includedData", "summaries"], ["marketplaceIds", "UK"]],
        URI.decode_www_form(first[1].split("?", 2)[1]).sort)
      respond(socket, body: "raw")
    }) do |url|
      engine = Peddler::Native::Engine.new(url, "local-secret", 5)
      status, _headers, body = engine.operation(CATALOG, JSON.generate(asin: "X", marketplace_ids: ["UK"]))

      assert_equal(200, status)
      assert_equal("raw".b, body)
      assert_equal(Encoding::BINARY, body.encoding)
    end
  end

  def test_generated_operations_allow_concurrent_calls_and_ruby_progress
    arrived = Queue.new
    release = Queue.new
    serve(count: 2, handler: lambda { |socket, *|
      arrived << true
      release.pop
      respond(socket)
    }) do |url|
      instance = client(url)
      calls = [Thread.new { instance.catalog_items_2022_04_01.get_catalog_item(asin: "X", marketplace_ids: ["UK"]) },
        Thread.new { instance.listings_items_2021_08_01.patch_listings_item(seller_id: "S", sku: "X", marketplace_ids: ["UK"], body: {}) }]
      Timeout.timeout(3) { 2.times { arrived.pop } }
      2.times { release << true }
      calls.each do |thread|
        assert(thread.join(3), "native operation did not finish")
        assert_equal(200, thread.value.status)
      end
    ensure
      calls&.each(&:kill)
      calls&.each(&:join)
    end
  end

  def test_generated_operation_interrupt_closes_socket_and_allows_reuse
    arrived = Queue.new
    closed = Queue.new
    serve(count: 2, handler: lambda { |socket, first, *|
      if first[1].start_with?("/catalog/")
        arrived << true

        assert(socket.wait_readable(2), "cancelled operation connection stayed open")
        assert_nil(socket.read(1))
        closed << true
      else
        respond(socket)
      end
    }) do |url|
      instance = client(url)
      worker = Thread.new do
        instance.catalog_items_2022_04_01.get_catalog_item(asin: "X", marketplace_ids: ["UK"])
      rescue Interrupt => error
        error
      end
      Timeout.timeout(3) { arrived.pop }
      worker.raise(Interrupt, "stop operation")

      assert(worker.join(2), "interrupt waited for operation timeout")
      assert_instance_of(Interrupt, worker.value)
      assert_equal("stop operation", worker.value.message)
      Timeout.timeout(3) { closed.pop }

      assert_equal(200, instance.listings_items_2021_08_01.patch_listings_item(seller_id: "S", sku: "X", marketplace_ids: ["UK"], body: {}).status)
    ensure
      worker&.kill
      worker&.join
    end
  end

  def test_generated_operation_timeout_closes_socket
    serve(handler: lambda { |socket, *|
      assert(socket.wait_readable(2), "timed-out operation connection stayed open")
      assert_nil(socket.read(1))
    }) do |url|
      assert_raises(Peddler::Native::TimeoutError) do
        client(url, timeout: 0.05).catalog_items_2022_04_01.get_catalog_item(asin: "X", marketplace_ids: ["UK"])
      end
    end
  end

  def test_generated_operation_fork_guard_and_fresh_child_client
    skip "fork unavailable" unless Process.respond_to?(:fork)

    serve(count: 2, handler: ->(socket, *) { respond(socket) }) do |url|
      instance = client(url)

      assert_equal(200, instance.catalog_items_2022_04_01.get_catalog_item(asin: "X", marketplace_ids: ["UK"]).status)
      reader, writer = IO.pipe
      pid = fork do
        reader.close
        begin
          instance.catalog_items_2022_04_01.get_catalog_item(asin: "X", marketplace_ids: ["UK"])
          raise "inherited operation client accepted"
        rescue Peddler::Native::ForkError
          instance = nil
          GC.start
          fresh = client(url)
          raise "fresh operation failed" unless fresh.listings_items_2021_08_01
            .patch_listings_item(seller_id: "S", sku: "X", marketplace_ids: ["UK"], body: {}).status == 200
          fresh = nil
          GC.start
          writer.write("ok")
        ensure
          writer.close
        end
        exit!(0)
      end
      writer.close

      assert(reader.wait_readable(5), "fork operation deadline")
      assert_equal("ok", reader.read)
      Process.wait(pid)

      assert_predicate($?, :success?)
    ensure
      reader&.close
      writer&.close unless writer&.closed?
      if pid
        begin
          Process.kill("KILL", pid)
          Process.wait(pid)
        rescue Errno::ESRCH, Errno::ECHILD
          nil
        end
      end
    end
  end
end
# rubocop:enable Minitest/MultipleAssertions
