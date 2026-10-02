# frozen_string_literal: true

require_relative "test_helper"

# Replays the fixtures shared with the Rust tests through the native Engine.
# rubocop:disable Minitest/MultipleAssertions
class PaginationTest < NativeTest
  CASES = JSON.parse(File.read(File.expand_path("../test/fixtures/native/pagination/cases.json", __dir__)))
  SECRET = "private-pagination-token"
  ORDERS = "orders_v0.get_orders"

  # Serves scripted replies, one request per connection, and keeps serving
  # past the script with a 500 so an unexpected fetch shows up in `requests`.
  class Script
    attr_reader :url, :requests

    def initialize(replies)
      @replies = replies
      @requests = []
      @lock = Mutex.new
      @server = TCPServer.new("127.0.0.1", 0)
      @url = "http://127.0.0.1:#{@server.addr[1]}"
      @thread = Thread.new { loop { serve(@server.accept) } }
    end

    def close
      @thread.kill
      @server.close
    end

    private

    def serve(socket)
      Thread.new do
        method, target = socket.gets("\r\n").split
        headers = {}
        while (line = socket.gets("\r\n")) != "\r\n"
          key, value = line.split(":", 2)
          headers[key.downcase] = value.strip
        end
        body = socket.read(headers.fetch("content-length", "0").to_i)
        status, text = @lock.synchronize do
          @requests << { method: method, target: target, body: body, headers: headers }
          @replies.fetch(@requests.size - 1, [500, "unexpected extra request"])
        end
        socket.write("HTTP/1.1 #{status} Test\r\nContent-Length: #{text.bytesize}\r\nConnection: close\r\n\r\n#{text}")
      ensure
        socket.close
      end
    end
  end

  def script(replies)
    script = Script.new(replies)
    yield script
  ensure
    script&.close
  end

  def pagination_for(spec)
    return Peddler::Native::PAGINATIONS.fetch(spec) if spec.is_a?(String)

    continuation = spec.fetch("continuation", {})
    Peddler::Pagination.new(operation: spec["operation"], input: spec["input"], output: spec["output"],
      continuation: Peddler::Continuation.new(
        operation: continuation["operation"], keep: continuation["keep"], drop: continuation.fetch("drop", []),
        set: continuation.fetch("set", {}),
      ))
  end

  def deep_freeze(value)
    case value
    when Hash then value.each { |k, v| deep_freeze(k) && deep_freeze(v) }
    when Array then value.each { |v| deep_freeze(v) }
    end
    value.freeze
  end

  def decoded(request)
    path, query = request[:target].split("?", 2)
    [path, URI.decode_www_form(query.to_s).sort]
  end

  CASES.each_with_index do |fixture, index|
    define_method(:"test_shared_case_#{index}_#{fixture["name"].gsub(/\W+/, "_")}") do
      replies = fixture["responses"].map { |r| [r["status"], r["body"]] }
      arguments = deep_freeze(JSON.parse(JSON.generate(fixture["arguments"])))
      script(replies) do |server|
        engine = client(server.url).instance_variable_get(:@engine)
        pages = []
        error = failed = nil
        begin
          pagination_for(fixture["pagination"]).pages(engine, arguments, max_pages: fixture["max_pages"]).each do |page|
            pages << page
          end
        rescue Peddler::PaginationError => e
          error = e
        rescue Peddler::Error => e
          failed = e
        end

        # The shared fixtures list a failed page as yielded, as the Rust stream does. Ruby raises it instead.
        assert_equal(fixture["statuses"], pages.map(&:status) + [failed&.status].compact)
        assert_equal(fixture["statuses"].any? { |status| status >= 400 }, !failed.nil?)
        expected_error = fixture["error"]
        expected_error ? assert_equal(expected_error, error&.reason&.to_s) : assert_nil(error)
        refute_includes("#{error&.message}#{error&.cause&.message}#{error&.inspect}", "SECRET") if error

        assert_nil(error&.cause)
        assert_equal(fixture["requests"].size, server.requests.size)
        fixture["requests"].zip(server.requests).each do |want, got|
          assert_equal("application/json", got[:headers]["accept"])
          assert_equal(want["method"], got[:method])
          assert_equal([want["path"], want["query"].sort], decoded(got))
          want_body = want["body"]
          want_body ? assert_equal(want_body, JSON.parse(got[:body])) : assert_empty(got[:body])
        end
      end
    end
  end

  def test_generated_pages_raise_the_api_error_on_a_failed_page
    replies = [[200, '{"payload":{"Orders":[],"NextToken":"A"}}'], [429, '{"errors":[{"code":"QuotaExceeded","message":"Slow down"}]}']]
    script(replies) do |server|
      pages = []
      error = assert_raises(Peddler::Error) do
        client(server.url).orders_v0.get_orders_pages(marketplace_ids: ["ATVPDKIKX0DER"]).each { |page| pages << page }
      end

      assert_equal([200], pages.map(&:status))
      assert_instance_of(Peddler::APIs::OrdersV0::GetOrdersResponse, pages.first.parse)
      assert_equal([429, "QuotaExceeded", "Slow down"], [error.status, error.code, error.message])
      assert_equal(2, server.requests.size)
    end
  end

  def test_generated_method_returns_a_lazy_rewindable_enumerable_of_native_responses
    script([[200, '{"payload":{"NextToken":"A"}}'], [200, "{}"], [200, '{"payload":{"NextToken":"A"}}'], [200, "{}"]]) do |server|
      enum = client(server.url).orders_v0.get_orders_pages(marketplace_ids: ["ATVPDKIKX0DER"])

      assert_kind_of(Enumerable, enum)
      assert_empty(server.requests, "no network before enumeration")
      assert_equal([200, 200], enum.map(&:status))
      assert_instance_of(Peddler::Response, enum.first)
      assert_equal(3, server.requests.size, "first restarts from the first page and stops")
      assert_equal(["NextToken", "A"], URI.decode_www_form(server.requests[1][:target].split("?", 2)[1]).assoc("NextToken"))
    end
  end

  def test_early_break_and_abandonment_never_fetch_another_page
    script([[200, '{"payload":{"NextToken":"A"}}'], [200, '{"payload":{"NextToken":"B"}}']]) do |server|
      pages = client(server.url).orders_v0.get_orders_pages(marketplace_ids: ["ATVPDKIKX0DER"])
      pages.each { break }

      assert_equal(1, server.requests.size)
      external = pages.each
      external.next
      sleep(0.1)

      assert_equal(2, server.requests.size, "a fresh external enumeration fetched only its first page")
    end
  end

  def test_unmutated_caller_arguments_with_symbol_and_string_keys
    script([[200, '{"cases":[],"nextToken":"A"}'], [200, '{"cases":[]}']]) do |server|
      body = deep_freeze({ maxResults: 2, "sortOrder" => "ASC" })
      arguments = deep_freeze({ body: body })
      engine = client(server.url).instance_variable_get(:@engine)
      pagination = Peddler::Native::PAGINATIONS.fetch("support_2025_02_01.list_cases")

      assert_equal(2, pagination.pages(engine, arguments).to_a.size)
      assert_equal({ "maxResults" => 2, "sortOrder" => "ASC", "nextToken" => "A" }, JSON.parse(server.requests[1][:body]))
      assert_equal({ body: { maxResults: 2, "sortOrder" => "ASC" } }, arguments)
    end
  end

  def test_client_pages_runs_explicit_mapping
    script([[200, '{"next":"1"}'], [200, "{}"]]) do |server|
      pagination = Peddler::Pagination.new(operation: "sellers_v1.get_marketplace_participations", input: "/x",
        output: "/next")

      assert_equal(1, client(server.url).pages(pagination, {}, max_pages: 1).to_a.size)
      assert_equal(1, server.requests.size)
    end
  end

  def test_argument_and_mapping_validation_fails_before_any_request
    script([]) do |server|
      engine = client(server.url).instance_variable_get(:@engine)
      pagination = Peddler::Native::PAGINATIONS.fetch(ORDERS)

      assert_raises(ArgumentError) { pagination.pages(engine, []) }
      assert_raises(ArgumentError) { pagination.pages(engine, { next_token: 5 }) }
      assert_raises(ArgumentError) { pagination.pages(engine, { "a" => 1, a: 2 }) }
      assert_raises(ArgumentError) { pagination.pages(engine, {}, max_pages: -1) }
      assert_raises(ArgumentError) { pagination.pages(engine, { x: Float::NAN }) }
      assert_raises(ArgumentError) do
        Peddler::Pagination.new(operation: ORDERS, input: "next_token", output: "/x")
      end
      assert_empty(server.requests)
    end
  end

  def test_each_page_goes_through_normal_per_page_retries_and_auth_header
    script([[503, "busy"], [200, '{"payload":{"NextToken":"A"}}'], [200, "{}"]]) do |server|
      pages = client(server.url, retries: 1, retry_delay: 0.001).orders_v0.get_orders_pages(marketplace_ids: ["ATVPDKIKX0DER"])

      assert_equal([200, 200], pages.map(&:status))
      assert_equal(3, server.requests.size)
      assert(server.requests.all? { |r| r[:headers]["x-amz-access-token"] == "local-secret" })
    end
  end
end
# rubocop:enable Minitest/MultipleAssertions
