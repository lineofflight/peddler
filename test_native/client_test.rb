# frozen_string_literal: true

require_relative "test_helper"

# Protocol and lifecycle tests assert several parts of one interaction.
# rubocop:disable Minitest/MultipleAssertions
class ClientTest < NativeTest
  def test_binary_body_escaped_path_and_repeated_headers
    handler = lambda do |socket, first, _headers, body|
      assert_equal("/items/a%2Fb%20c?search=a%26b&count=2&active=false", first[1])
      assert_equal("\xFF\x00".b, body)
      respond(socket, headers: [["x-repeat", "a"], ["x-repeat", "b"]], body: "\xFF\x00".b)
    end
    serve(handler: handler) do |url|
      result = client(url).request("POST", "/items/a%2Fb%20c", params: { search: "a&b", count: 2, active: false }, body: "\xFF\x00".b)

      assert_equal("\xFF\x00".b, result.body)
      assert_equal([["x-repeat", "a"], ["x-repeat", "b"]], result.headers.select { |key, _| key == "x-repeat" })
      assert_raises(JSON::ParserError) { result.to_h }
    end
  end

  # Amazon's servers, and the retries of a GET, take a method in uppercase.
  def test_a_method_in_lowercase_is_sent_in_uppercase
    seen = Queue.new
    serve(count: 2, handler: lambda { |socket, first, *|
      seen << first[0]
      respond(socket)
    }) do |url|
      instance = client(url)

      ["get", "Post"].each { |method| assert_equal(200, instance.request(method, "/").status) }
    end

    assert_equal(["GET", "POST"], Array.new(2) { seen.pop })
  end

  def test_json_body_serialization
    serve(handler: lambda { |socket, _first, _headers, body|
      assert_equal({ "value" => [1, true] }, JSON.parse(body))
      respond(socket)
    }) do |url|
      assert_equal(200, client(url).request("POST", "/", body: { value: [1, true] }).status)
    end
  end

  def test_a_parameter_value_is_sent_as_an_argument_of_an_operation_is
    uk = Peddler::Marketplace.find("UK")
    serve_keep_alive do |url, _accepted, requests|
      instance = client(url)
      instance.request("GET", "/x", params: { MarketplaceIds: uk, ids: ["a b", uk, 3, true], none: [], "n" => 1.5, s: :sym })

      assert_equal("/x?MarketplaceIds=A1F83G8C2ARO7P&ids=a+b%2CA1F83G8C2ARO7P%2C3%2Ctrue&none=&n=1.5&s=sym", requests.pop[1])
      rule = "must be a String, a finite number, a boolean or an Array of them"
      {
        { key: nil } => "key #{rule}",
        { key: Object.new } => "key #{rule}",
        { key: Float::INFINITY } => "key #{rule}",
        { key: { SENTINEL.to_sym => 1 } } => "key #{rule}",
        { key: [[SENTINEL]] } => "key #{rule}",
        { key: "#{SENTINEL}\xFF" } => "key must be valid UTF-8",
        { "#{SENTINEL}\xFF" => "value" } => "parameter names must be valid UTF-8",
      }.each do |params, message|
        error = assert_raises(ArgumentError) { instance.request("GET", "/x", params: params) }

        assert_equal(message, error.message)
        assert_nil(error.cause)
        refute_includes(error.full_message(highlight: false).b, SENTINEL)
      end
      assert_empty(requests)
    end
  end

  def test_rejects_unsupported_or_ambiguous_inputs
    instance = client("http://127.0.0.1:1")

    [nil, [], { key: nil }, { key: {} }, { 1 => "value" }, { key: "a", "key" => "b" }, { key: Float::NAN }].each do |params|
      assert_raises(ArgumentError) { instance.request("GET", "/", params: params) }
    end
    [false, 1, Object.new].each do |body|
      assert_raises(ArgumentError) { instance.request("POST", "/", body: body) }
    end
    ["//elsewhere", "/bad%", "/?secret=value", "/secret#value", "/a b", "relative"].each do |path|
      error = assert_raises(ArgumentError) { instance.request("GET", path) }

      assert_equal("path must be an absolute path, percent-encoded, without a query or fragment", error.message)
    end
    ["bad method", ""].each do |method|
      error = assert_raises(ArgumentError) { instance.request(method, "/") }

      assert_equal("method must be an HTTP method", error.message)
    end
    {
      -> { instance.request(:get, "/") } => "method must be a String",
      -> { instance.request("GET", nil) } => "path must be a String",
      -> { instance.request("#{SENTINEL}\xFF", "/") } => "method must be an HTTP method",
      -> { instance.request("GET", "/#{SENTINEL}\xFF") } => "path must be valid UTF-8",
    }.each do |call, message|
      error = assert_raises(ArgumentError, &call)

      assert_equal(message, error.message)
      assert_nil(error.cause)
      refute_includes(error.full_message(highlight: false).b, SENTINEL)
    end
    [0, -1, Float::INFINITY, Float::NAN].each do |timeout|
      assert_raises(ArgumentError) { client("http://127.0.0.1:1", timeout: timeout) }
    end
    assert_raises(ArgumentError) { client("https://user:secret@example.com") }
    assert_raises(ArgumentError) { Peddler::Client.new(base_url: "http://127.0.0.1:1", access_token: "token\r\n") }
  end

  def test_transport_error_redacts_sensitive_data
    server = TCPServer.new("127.0.0.1", 0)
    url = "http://127.0.0.1:#{server.addr[1]}"
    server.close
    error = assert_raises(Peddler::TransportError) { client(url).request("GET", "/secret", params: { token: SENTINEL }) }
    refute_match(/secret|127\.0\.0\.1/, error.message)
    refute_includes(error.message, SENTINEL)
  end

  def test_timeout
    serve(handler: lambda { |socket, *|
      assert(socket.wait_readable(2), "timed-out connection stayed open")
      assert_nil(socket.read(1))
    }) do |url|
      started = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      assert_raises(Peddler::TimeoutError) { client(url, timeout: 0.05).request("GET", "/") }
      assert_operator(Process.clock_gettime(Process::CLOCK_MONOTONIC) - started, :<, 2)
    end
  end

  def test_concurrent_calls_and_ruby_thread_progress
    arrived = Queue.new
    release = Queue.new
    handler = lambda do |socket, *|
      arrived << true
      release.pop
      respond(socket)
    end
    serve(count: 2, handler: handler) do |url|
      instance = client(url)
      calls = Array.new(2) { Thread.new { instance.request("GET", "/") } }
      Timeout.timeout(3) { 2.times { arrived.pop } }
      2.times { release << true }
      calls.each do |thread|
        assert(thread.join(3), "native call did not finish")
        assert_equal(200, thread.value.status)
      end
    ensure
      calls&.each(&:kill)
      calls&.each(&:join)
    end
  end

  def test_thread_raise_cancels_in_flight_request_and_client_remains_usable
    arrived = Queue.new
    closed = Queue.new
    handler = lambda do |socket, first, *|
      if first[1] == "/wait"
        arrived << true

        assert(socket.wait_readable(2), "cancelled connection stayed open")
        assert_nil(socket.read(1))
        closed << true
      else
        respond(socket)
      end
    end
    serve(count: 2, handler: handler) do |url|
      instance = client(url)
      worker = Thread.new do
        instance.request("GET", "/wait")
      rescue Interrupt => error
        error
      end
      Timeout.timeout(3) { arrived.pop }
      worker.raise(Interrupt, "stop native request")

      assert(worker.join(2), "interrupt waited for request timeout")
      assert_instance_of(Interrupt, worker.value)
      assert_equal("stop native request", worker.value.message)
      Timeout.timeout(3) { closed.pop }

      assert_equal(200, instance.request("GET", "/").status)
    ensure
      worker&.kill
      worker&.join
    end
  end

  # Ruby wakes a thread for more than an exception. Only an exception ends its call: the server answers each
  # request below after the wake-up was dealt with.

  def test_a_trapped_signal_does_not_cancel_the_request_in_flight
    skip "Windows has no SIGUSR1" unless Signal.list.key?("USR1")

    trapped = Queue.new
    previous = trap("USR1") { trapped << true }
    begin
      arrived = Queue.new
      handler = lambda do |socket, *|
        arrived << true
        Timeout.timeout(3) { trapped.pop }
        respond(socket)
      end
      serve(handler: handler) do |url|
        signaller = Thread.new do
          Timeout.timeout(3) { arrived.pop }
          Process.kill("USR1", Process.pid)
        end

        # Ruby runs a trap on the main thread, which is the thread of this test.
        assert_equal(200, client(url).request("POST", "/", body: {}).status)
        signaller.join
      end
    ensure
      trap("USR1", previous || "DEFAULT")
    end
  end

  def test_thread_wakeup_does_not_cancel_the_request_in_flight
    arrived = Queue.new
    release = Queue.new
    handler = lambda do |socket, *|
      arrived << true
      Timeout.timeout(3) { release.pop }
      respond(socket)
    end
    serve(handler: handler) do |url|
      instance = client(url)
      worker = Thread.new { instance.request("GET", "/") }
      Timeout.timeout(3) { arrived.pop }
      3.times { worker.wakeup }
      release << true

      assert(worker.join(3), "request did not finish")
      assert_equal(200, worker.value.status)
    ensure
      worker&.kill
      worker&.join
    end
  end

  def test_a_masked_thread_raise_waits_for_the_request_in_flight
    arrived = Queue.new
    release = Queue.new
    handler = lambda do |socket, *|
      arrived << true
      Timeout.timeout(3) { release.pop }
      respond(socket)
    end
    serve(handler: handler) do |url|
      instance = client(url)
      worker = Thread.new do
        response = nil
        begin
          Thread.handle_interrupt(RuntimeError => :never) { response = instance.request("GET", "/") }
        rescue RuntimeError => error
          [response, error]
        end
      end
      Timeout.timeout(3) { arrived.pop }
      worker.raise("deferred")
      release << true

      assert(worker.join(3), "request did not finish")
      response, error = worker.value

      assert_equal(200, response.status)
      assert_equal("deferred", error.message)
    ensure
      worker&.kill
      worker&.join
    end
  end
end

# rubocop:enable Minitest/MultipleAssertions
