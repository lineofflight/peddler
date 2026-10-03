# frozen_string_literal: true

require_relative "test_helper"

# The optional in-process token source of Peddler::LWA, over a loopback server that counts token requests.
# rubocop:disable Minitest/MultipleAssertions
class LwaTokenSourceTest < NativeTest
  # Serves LWA at /auth, handing out access-1, access-2 and so on, and anything else as the API.
  # Yields the URL, the token requests made so far and the API requests.
  def serve_lwa(expires_in: 3600, gate: nil, rejections: [])
    exchanges = Queue.new
    responder = lambda do |_method, target, _headers, body|
      next [200, "{}"] unless target == "/auth"

      exchanges << body
      gate&.pop
      next [401, JSON.generate(error: rejections.shift, error_description: "sensitive description")] unless rejections.empty?

      [200, JSON.generate(access_token: "access-#{exchanges.size}", token_type: "bearer", expires_in: expires_in)]
    end
    serve_keep_alive(responder: responder) { |url, _accepted, requests| yield url, exchanges, requests }
  end

  def lwa(url)
    Peddler::LWA.new(client_id: "app-id", client_secret: "app-secret", lwa_endpoint: "#{url}/auth")
  end

  def monotonic
    Process.clock_gettime(Process::CLOCK_MONOTONIC)
  end

  def wait_until_asleep(threads)
    Timeout.timeout(5) { sleep(0.01) until threads.all? { |thread| thread.status == "sleep" } }
  end

  def test_ten_threads_share_one_refresh_and_later_calls_ask_nothing
    gate = Queue.new
    serve_lwa(gate: gate) do |url, exchanges, _requests|
      source = lwa(url).token_source(refresh_token: "sensitive-refresh")
      threads = Array.new(10) { Thread.new { source.call } }
      wait_until_asleep(threads)
      gate << true

      assert_equal(["access-1"] * 10, threads.map(&:value))
      assert_equal(1, exchanges.size)
      assert_equal("grant_type=refresh_token&client_id=app-id&client_secret=app-secret&refresh_token=sensitive-refresh", exchanges.pop)
      # Within the token's lifetime nothing more is requested.
      5.times { assert_equal("access-1", source.call) }
      assert_empty(exchanges)
    ensure
      10.times { gate << true }
    end
  end

  def test_refreshes_60_seconds_early_and_a_tenth_early_for_short_lifetimes
    # Both later instants are before the token expires, so a source that only refreshed at expiry would fail here.
    { 3600 => [3539, 3545], 10 => [8.9, 9.5] }.each do |expires_in, (before, after)|
      serve_lwa(expires_in: expires_in) do |url, exchanges, _requests|
        source = lwa(url).token_source(refresh_token: "refresh")
        started = monotonic

        assert_equal("access-1", source.call)
        source.stub(:now, started + before) { assert_equal("access-1", source.call) }
        assert_equal(1, exchanges.size)
        # Past the early-refresh point the next call makes exactly 1 request and returns the new token.
        source.stub(:now, started + after) do
          assert_equal("access-2", source.call)
          assert_equal("access-2", source.call)
        end
        assert_equal(2, exchanges.size)
      end
    end
  end

  def test_a_failed_refresh_reaches_every_waiter_is_not_kept_and_the_next_call_recovers
    gate = Queue.new
    serve_lwa(gate: gate, rejections: ["invalid_grant"]) do |url, exchanges, _requests|
      source = lwa(url).token_source(refresh_token: "sensitive-refresh")
      threads = Array.new(3) do
        Thread.new do
          source.call
        rescue Peddler::AuthenticationError => error
          error
        end
      end
      wait_until_asleep(threads)
      gate << true
      errors = threads.map(&:value)

      assert_equal(1, exchanges.size)
      errors.each do |error|
        assert_instance_of(Peddler::AuthenticationError, error)
        assert_equal(["invalid_grant", 401], [error.code, error.status])
        refute_match(/sensitive/, "#{error.message} #{error.inspect}")
      end
      # Nothing was kept, so the next call asks again.
      gate << true

      assert_equal("access-2", source.call)
      assert_equal(2, exchanges.size)
    ensure
      10.times { gate << true }
    end
  end

  def test_scope_source_makes_one_client_credentials_exchange
    serve_lwa do |url, exchanges, _requests|
      source = lwa(url).token_source(scope: "sellingpartnerapi::notifications")

      2.times { assert_equal("access-1", source.call) }
      assert_equal(["grant_type=client_credentials&client_id=app-id&client_secret=app-secret&scope=sellingpartnerapi%3A%3Anotifications"],
        Array.new(exchanges.size) { exchanges.pop })
    end
  end

  def test_an_interrupted_refresh_closes_its_socket_and_a_waiter_or_later_call_recovers
    started = Queue.new
    closed = Queue.new
    calls = 0
    serve(count: 2, handler: lambda { |socket, *|
      calls += 1
      if calls == 1
        started << true

        assert(socket.wait_readable(2), "interrupted connection stayed open")
        assert_nil(socket.read(1))
        closed << true
      else
        respond(socket, body: JSON.generate(access_token: "recovered", token_type: "bearer", expires_in: 3600))
      end
    }) do |url|
      source = Peddler::LWA.new(client_id: "id", client_secret: "secret", lwa_endpoint: url).token_source(refresh_token: "refresh")
      leader = Thread.new { source.call }
      Timeout.timeout(3) { started.pop }
      follower = Thread.new { source.call }
      wait_until_asleep([follower])
      leader.kill
      leader.join
      Timeout.timeout(3) { closed.pop }

      # The waiter takes over with a request of its own, and the token it gets is kept.
      assert_equal("recovered", follower.value)
      assert_equal("recovered", source.call)
    ensure
      [leader, follower].each { |thread| thread&.kill }
    end
  end

  def test_inspect_shows_no_secret_and_arguments_are_checked
    serve_lwa do |url, _exchanges, _requests|
      helper = lwa(url)
      source = helper.token_source(refresh_token: "sensitive-refresh")

      assert_equal("access-1", source.call)
      refute_match(/sensitive-refresh|access-1|app-secret|app-id/, "#{source.inspect} #{source}")
      assert_respond_to(source, :call)
      [{}, { refresh_token: "refresh", scope: "scope" }].each do |options|
        error = assert_raises(ArgumentError) { helper.token_source(**options) }

        assert_equal("provide either refresh_token or scope", error.message)
      end
      [{ refresh_token: "" }, { refresh_token: " " }, { refresh_token: 1 }, { refresh_token: "sensitive-\xFF" },
        { scope: "" }, { scope: :scope }, { scope: "sensitive-\xFF".b }].each do |options|
        error = assert_raises(ArgumentError, options.inspect) { helper.token_source(**options) }

        refute_match(/sensitive/, error.message)
      end
    end
  end

  def test_a_source_created_before_fork_raises_in_the_child_even_with_a_fresh_token
    skip "fork unavailable" unless Process.respond_to?(:fork)

    serve_lwa do |url, exchanges, _requests|
      source = lwa(url).token_source(refresh_token: "refresh")

      assert_equal("access-1", source.call)
      reader, writer = IO.pipe
      pid = fork do
        reader.close
        begin
          source.call
          writer.write("accepted")
        rescue Peddler::ForkError
          writer.write("guarded ")
          writer.write(lwa(url).token_source(refresh_token: "refresh").call)
        end
        writer.close
        exit!(0)
      end
      writer.close

      assert(reader.wait_readable(10), "fork deadline")
      assert_equal("guarded access-2", reader.read)
      Process.wait(pid)

      assert_equal("access-1", source.call)
      assert_equal(2, exchanges.size)
    ensure
      reader&.close
      writer&.close unless writer&.closed?
    end
  end
end
# rubocop:enable Minitest/MultipleAssertions
