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

  def test_json_body_serialization
    serve(handler: lambda { |socket, _first, _headers, body|
      assert_equal({ "value" => [1, true] }, JSON.parse(body))
      respond(socket)
    }) do |url|
      assert_equal(200, client(url).request("POST", "/", body: { value: [1, true] }).status)
    end
  end

  def test_rejects_unsupported_or_ambiguous_inputs
    instance = client("http://127.0.0.1:1")

    [nil, [], { key: nil }, { key: [] }, { key: {} }, { 1 => "value" }, { key: "a", "key" => "b" }, { key: Float::NAN }].each do |params|
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
    assert_raises(TypeError) { instance.request(:get, "/") }
    assert_raises(TypeError) { instance.request("GET", nil) }
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
    error = assert_raises(Peddler::TransportError) { client(url).request("GET", "/secret", params: { token: "private" }) }
    refute_match(/secret|private|127\.0\.0\.1/, error.message)
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
end

# rubocop:enable Minitest/MultipleAssertions
