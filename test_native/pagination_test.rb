# frozen_string_literal: true

require_relative "test_helper"

# Replays the fixtures shared with the Rust tests through the native Engine.
# rubocop:disable Minitest/MultipleAssertions
class PaginationTest < NativeTest
  CASES = JSON.parse(File.read(File.expand_path("../test/fixtures/native/pagination/cases.json", __dir__)))
  SECRET = "private-pagination-token"
  ORDERS = "orders_v0.get_orders"

  # The URL and the requests so far, each as a hash of method, target, headers and body
  Served = Struct.new(:url, :queue) do
    def requests
      @requests ||= []
      @requests.concat(Array.new(queue.size) { queue.pop }.map { |method, target, headers, body| { method:, target:, headers:, body: } })
    end
  end

  # Answers each request with the next scripted reply, then with a 500, so an unexpected fetch shows up in `requests`
  def script(replies)
    lock = Mutex.new
    served = 0
    responder = ->(*) { lock.synchronize { replies.fetch((served += 1) - 1, [500, "unexpected extra request"]) } }
    serve_keep_alive(responder: responder) { |url, _accepted, queue| yield Served.new(url, queue) }
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
        client(server.url).orders_v0.get_orders_pages(["ATVPDKIKX0DER"]).each { |page| pages << page }
      end

      assert_equal([200], pages.map(&:status))
      assert_instance_of(Peddler::APIs::OrdersV0::GetOrdersResponse, pages.first.parse)
      assert_equal([429, "QuotaExceeded", "Slow down"], [error.status, error.code, error.message])
      assert_equal(2, server.requests.size)
    end
  end

  def test_generated_method_returns_a_lazy_rewindable_enumerable_of_native_responses
    script([[200, '{"payload":{"NextToken":"A"}}'], [200, "{}"], [200, '{"payload":{"NextToken":"A"}}'], [200, "{}"]]) do |server|
      enum = client(server.url).orders_v0.get_orders_pages(["ATVPDKIKX0DER"])

      assert_kind_of(Enumerable, enum)
      assert_empty(server.requests, "no network before enumeration")
      # A caller that changes the token in a page doesn't change the one sent next.
      assert_equal([200, 200], enum.map { |page| page.tap { _1.dig("payload", "NextToken")&.replace("changed") }.status })
      assert_instance_of(Peddler::Response, enum.first)
      assert_equal(3, server.requests.size, "first restarts from the first page and stops")
      assert_equal(["NextToken", "A"], URI.decode_www_form(server.requests[1][:target].split("?", 2)[1]).assoc("NextToken"))
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
end
# rubocop:enable Minitest/MultipleAssertions
