# frozen_string_literal: true

require_relative "test_helper"

# The access token may be a source the client asks before each attempt of a call.
# rubocop:disable Minitest/MultipleAssertions
class TokenSourceTest < NativeTest
  PAGES = ['{"payload":{"NextToken":"A"}}', '{"payload":{"NextToken":"B"}}', '{"payload":{}}'].freeze

  # A source that hands out token-1, token-2 and so on, and the number of calls so far.
  def counting_source
    calls = 0
    [-> { "token-#{calls += 1}" }, -> { calls }]
  end

  def tokens(requests, count)
    Array.new(count) { requests.pop }.map { |_, _, headers, _| headers["x-amz-access-token"] }
  end

  def test_source_is_asked_once_per_operation_request_and_page
    pages = PAGES.dup
    responder = ->(_method, target, *) { [200, target.start_with?("/orders/v0/orders?") ? pages.shift : "{}"] }
    serve_keep_alive(responder: responder) do |url, accepted, requests|
      source, calls = counting_source
      instance = Peddler::Client.new(base_url: url, access_token: source)

      assert_equal(0, calls.call, "construction asks nothing")
      assert_equal(200, instance.catalog_items_2022_04_01.get_catalog_item("ASIN", ["UK"]).status)
      assert_equal(200, instance.request("GET", "/").status)
      enumerator = instance.orders_v0.get_orders_pages(["UK"])

      assert_equal(2, calls.call, "a lazy enumerator asks nothing until a page is requested")
      assert_equal(3, enumerator.count)
      assert_equal(["token-1", "token-2", "token-3", "token-4", "token-5"], tokens(requests, 5))
      assert_equal(5, calls.call)
      # A token per call costs no connection: the calls shared the pool, which may have opened a second.
      assert_operator(accepted.size, :<=, 2)
    end
  end

  # The source is Ruby and the retries are the core's, which asks it in the middle of the call.
  def test_source_is_asked_before_every_attempt_and_a_retry_sends_a_fresh_token
    statuses = [429, 503, 200, 200]
    responder = ->(*) { [statuses.shift, "{}", [["Retry-After", "0"]]] }
    serve_keep_alive(responder: responder) do |url, accepted, requests|
      source, calls = counting_source
      instance = Peddler::Client.new(base_url: url, access_token: source, retries: 2)

      assert_equal(200, instance.request("GET", "/").status)
      assert_equal(3, calls.call)
      assert_equal(200, instance.request("GET", "/").status)
      assert_equal(["token-1", "token-2", "token-3", "token-4"], tokens(requests, 4))
      assert_operator(accepted.size, :<=, 2)
    end
  end

  # `get_orders` allows 1 request a minute, so by its rate the first retry would wait a minute. At 100 requests a
  # second it waits 10 milliseconds and the second 20, and up to 100 more each. The source is asked after each wait.
  def test_a_call_with_a_rate_limit_asks_before_every_attempt_and_waits_by_that_rate
    statuses = [429, 429, 200]
    serve_keep_alive(responder: ->(*) { [statuses.shift, "{}"] }) do |url, _accepted, requests|
      source, calls = counting_source
      orders = Peddler::Client.new(base_url: url, access_token: source, retries: 2).orders_v0
      started = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      response = Timeout.timeout(10) { orders.get_orders(["ATVPDKIKX0DER"], rate_limit: 100) }
      elapsed = Process.clock_gettime(Process::CLOCK_MONOTONIC) - started

      assert_equal(200, response.status)
      assert_operator(elapsed, :>=, 0.03)
      assert_operator(elapsed, :<, 1)
      assert_equal(["token-1", "token-2", "token-3"], tokens(requests, 3))
      assert_equal(3, calls.call)
    end
  end

  # Asking is part of the attempt, as it is in the core. The timeout can't cut a source short, so a slow one is waited
  # for, and the attempt has then timed out: its token came too late, and nothing is sent with it. The connection
  # the first call left idle is neither written to nor closed, so the last call finds it.
  def test_timeout_limits_an_attempt_with_the_time_its_source_takes
    serve_keep_alive do |url, accepted, requests|
      slow = lambda do
        sleep(0.15)
        "token"
      end

      assert_equal(200, Peddler::Client.new(base_url: url, access_token: slow, timeout: 5).request("GET", "/").status)
      requests.pop
      instance = Peddler::Client.new(base_url: url, access_token: slow, timeout: 0.05)
      error = assert_raises(Peddler::TimeoutError) { instance.request("POST", "/late", body: {}) }

      assert_equal("request timed out", error.message)
      assert_empty(requests)
      assert_equal(200, client(url).request("GET", "/after").status)
      assert_equal(["/after"], Array.new(requests.size) { requests.pop }.map { |_, target, *| target })
      assert_equal(1, accepted.size)
    end
  end

  def test_string_and_source_views_replace_each_other
    serve_keep_alive do |url, _accepted, requests|
      source, calls = counting_source
      fixed = Peddler::Client.new(base_url: url, access_token: "fixed")
      sourced = fixed.with_access_token(source)

      assert_equal(200, fixed.request("GET", "/").status)
      assert_equal(200, sourced.request("GET", "/").status)
      assert_equal(200, sourced.with_access_token("pinned").request("GET", "/").status)
      assert_equal(200, sourced.with_access_token(-> { "other-source" }).request("GET", "/").status)
      assert_equal(200, sourced.request("GET", "/").status)
      assert_equal(["fixed", "token-1", "pinned", "other-source", "token-2"], tokens(requests, 5))
      assert_equal(2, calls.call)
      refute_match(/fixed|pinned|token-/, [fixed, sourced].map(&:inspect).join)
    end
  end

  def test_sandbox_view_of_a_sourced_client_asks_the_same_source
    serve_keep_alive do |url, _accepted, requests|
      source, calls = counting_source
      endpoint = Struct.new(:production, :sandbox).new(URI("http://127.0.0.1:1"), URI(url))
      instance = Peddler::Endpoint.stub(:find, endpoint) { Peddler::Client.new(region: "eu-west-1", access_token: source) }

      assert_same(instance.sandbox, instance.sandbox)
      2.times { assert_equal(200, instance.sandbox.request("GET", "/").status) }
      assert_equal(["token-1", "token-2"], tokens(requests, 2))
      assert_equal(2, calls.call)
    end
  end

  def test_helpers_whose_loop_runs_in_rust_ask_before_every_request_and_signed_urls_never_ask
    statuses = ["IN_QUEUE", "IN_PROGRESS", "DONE"]
    responder = lambda do |_method, target, *|
      next [200, "signed body"] if target.start_with?("/signed")

      [200, JSON.generate(reportId: "r1", reportType: "T", processingStatus: statuses.shift, createdTime: "2024-01-01T00:00:00Z", reportDocumentId: "d9")]
    end
    serve_keep_alive(responder: responder) do |url, _accepted, requests|
      source, calls = counting_source
      instance = Peddler::Client.new(base_url: url, access_token: source)

      assert_equal("DONE", instance.reports.wait_for_report("r1", interval: 0.01, timeout: 5).to_h.fetch("processingStatus"))
      assert_equal(["token-1", "token-2", "token-3"], tokens(requests, 3))
      assert_equal(3, calls.call)
      assert_equal("signed body", instance.download_document("#{url}/signed?sig=1") { |document| document.each_chunk.to_a.join })
      assert_nil(tokens(requests, 1).first)
      assert_equal(3, calls.call)
    end
  end

  def test_what_a_source_returns_is_validated_and_never_shown
    serve_keep_alive do |url, accepted, _requests|
      [nil, " ", "seller-secret-\xFF", "seller-secret\r\nx: y"].each do |value|
        instance = Peddler::Client.new(base_url: url, access_token: -> { value })
        error = assert_raises(ArgumentError, value.inspect) { instance.request("GET", "/") }

        assert_equal("invalid access token", error.message)
        refute_match(/seller-secret/, error.full_message(highlight: false))
        assert_nil(error.cause)
      end

      assert_equal(0, accepted.size, "no request reaches the server")
    end
    # A value that is neither a String nor callable is refused at once, as is a bad String.
    [nil, 123, :symbol, "", " ", "seller-secret-\xFF", "seller-secret\r\nx: y"].each do |value|
      [
        -> { Peddler::Client.new(base_url: "http://127.0.0.1:1", access_token: value) },
        -> { client("http://127.0.0.1:1").with_access_token(value) },
      ].each do |build|
        error = assert_raises(ArgumentError, value.inspect, &build)

        assert_equal("invalid access token", error.message)
        refute_match(/seller-secret/, error.full_message(highlight: false))
      end
    end
  end

  def test_an_exception_in_the_source_reaches_the_caller_as_the_same_object
    failure = Class.new(StandardError).new("cache is down")
    serve_keep_alive do |url, accepted, _requests|
      instance = Peddler::Client.new(base_url: url, access_token: -> { raise failure })
      [-> { instance.request("GET", "/") }, -> { instance.reports.wait_for_report("r1") }].each do |call|
        raised = assert_raises(failure.class, &call)

        assert_same(failure, raised)
        assert_nil(raised.cause)
      end

      assert_equal(0, accepted.size)
    end
  end

  def test_inspect_never_shows_what_a_source_object_holds
    source = Struct.new(:refresh_token) do
      def call = "token"
    end.new("sensitive-refresh")
    sourced = Peddler::Client.new(region: "eu-west-1", access_token: source)
    views = [sourced, sourced.sandbox, sourced.with_access_token(source),
      Peddler::Client.new(region: "eu-west-1", access_token: "fixed").with_access_token(source)]

    views.each { |view| refute_match(/sensitive-refresh/, view.inspect) }
    assert_match(/sensitive-refresh/, source.inspect, "the source itself does show its field")
  end

  def test_a_parent_built_client_does_not_call_its_source_in_a_forked_child
    skip "fork unavailable" unless Process.respond_to?(:fork)

    serve_keep_alive do |url, accepted, _requests|
      calls = 0
      instance = Peddler::Client.new(base_url: url, access_token: -> { "token-#{calls += 1}" })

      assert_equal(200, instance.request("GET", "/").status)
      reader, writer = IO.pipe
      pid = fork do
        reader.close
        result = begin
          instance.request("GET", "/")
          "accepted"
        rescue Peddler::ForkError
          "guarded"
        end
        writer.write(JSON.generate([result, calls]))
        writer.close
        exit!(0)
      end
      writer.close

      assert(reader.wait_readable(10), "fork deadline")
      # The child saw the 1 call the parent made before the fork and made none of its own.
      assert_equal(["guarded", 1], JSON.parse(reader.read))
      Process.wait(pid)

      assert_equal(200, instance.request("GET", "/").status)
      assert_equal(2, calls)
      assert_equal(1, accepted.size)
    ensure
      reader&.close
      writer&.close unless writer&.closed?
    end
  end
end
# rubocop:enable Minitest/MultipleAssertions
