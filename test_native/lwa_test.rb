# frozen_string_literal: true

require_relative "test_helper"

# Each test checks one protocol or lifecycle interaction.
# rubocop:disable Minitest/MultipleAssertions
class LwaTest < NativeTest
  def token_body(**overrides)
    JSON.generate({ access_token: "onboard-access", refresh_token: "onboard-refresh", token_type: "bearer", expires_in: 3600 }.merge(overrides))
  end

  def onboarding(url, **options)
    Peddler::Native::LWA.new(client_id: "id+&é", client_secret: "secret+&雪", lwa_endpoint: url, **options)
  end

  def test_authorization_code_form_and_refresh_integration
    assert(Peddler::Native.const_defined?(:LWA), "native onboarding is missing")
    calls = Queue.new
    serve(count: 2, handler: lambda { |socket, first, headers, body|
      assert_equal("POST", first[0])
      assert_equal("application/x-www-form-urlencoded", headers["content-type"])
      refute(headers.key?("x-amz-access-token"))
      refute(headers.key?("authorization"))
      refute_equal("application/json", headers["accept"])
      calls << body
      respond(socket, body: token_body)
    }) do |url|
      tokens = onboarding(url).exchange_authorization_code(code: "code+&λ", redirect_uri: "https://app.example/callback?state=a+b&x=雪")

      assert_equal("onboard-access", tokens.access_token)
      assert_equal("onboard-refresh", tokens.refresh_token)
      assert_equal("bearer", tokens.token_type)
      assert_equal(3600, tokens.expires_in)
      assert_equal({ access_token: "onboard-access", refresh_token: "onboard-refresh", token_type: "bearer", expires_in: 3600 }, tokens.to_h)
      refute_match(/onboard-access|onboard-refresh/, "#{tokens.inspect} #{tokens}")
      serve(handler: lambda { |socket, _first, headers, _body|
        assert_equal("onboard-access", headers["x-amz-access-token"])
        respond(socket)
      }) do |api|
        instance = Peddler::Client.new(base_url: api, client_id: "id", client_secret: "secret", refresh_token: tokens.refresh_token, lwa_endpoint: url)

        assert_equal(200, instance.request("GET", "/").status)
      end
    end

    assert_equal("grant_type=authorization_code&code=code%2B%26%CE%BB&client_id=id%2B%26%C3%A9&client_secret=secret%2B%26%E9%9B%AA&redirect_uri=https%3A%2F%2Fapp.example%2Fcallback%3Fstate%3Da%2Bb%26x%3D%E9%9B%AA", calls.pop)
    assert_equal("onboard-refresh", URI.decode_www_form(calls.pop).to_h["refresh_token"])
  end

  def test_sdk_grant_omits_redirect_uri
    serve(handler: lambda { |socket, _first, _headers, body|
      refute(URI.decode_www_form(body).to_h.key?("redirect_uri"))
      respond(socket, body: token_body)
    }) do |url|
      assert_equal("onboard-refresh", onboarding(url).exchange_authorization_code(code: "sdk-code").refresh_token)
    end
  end

  def test_invalid_response_fields_and_size_are_sanitized
    valid = JSON.parse(token_body)
    invalid = valid.keys.map { |key| valid.reject { |name, _| name == key } }
    invalid += [valid.merge("access_token" => ""), valid.merge("refresh_token" => " "), valid.merge("access_token" => "bad\nvalue"),
      valid.merge("token_type" => "basic"), valid.merge("expires_in" => 0), valid.merge("expires_in" => -1), valid.merge("expires_in" => "3600"), valid.merge("expires_in" => 1.5), valid.merge("expires_in" => 2**64)]
    bodies = invalid.map { |data| JSON.generate(data) } + ["sensitive malformed", "x" * (64 * 1024 + 1)]
    bodies.each do |body|
      serve(handler: ->(socket, *) { respond(socket, body: body) }) do |url|
        error = assert_raises(Peddler::Native::AuthenticationError) { onboarding(url).exchange_authorization_code(code: "sensitive-code") }
        refute_match(/sensitive-code|sensitive caller exception|onboard-access|onboard-refresh|secret\+&/, error.full_message)
        assert_nil(error.cause)
      end
    end
  end

  def sensitive_rescue
    raise "sensitive caller exception"
  rescue RuntimeError
    yield
  end

  def test_rejections_and_validation_clear_inherited_cause
    serve(handler: ->(socket, *) { respond(socket, status: 401, body: "sensitive-code secret+&雪") }) do |url|
      error = assert_raises(Peddler::Native::AuthenticationError) do
        sensitive_rescue { onboarding(url).exchange_authorization_code(code: "sensitive-code") }
      end
      assert_equal(401, error.status)
      assert_nil(error.cause)
      refute_match(/sensitive-code|sensitive caller exception|secret\+&/, error.full_message)
    end
    [{ client_id: "" }, { client_secret: " " }, { client_id: Object.new },
      { client_id: "\xFF" }, { client_id: "\xFF".b },
      { client_secret: "\xFF" }, { client_secret: "\xFF".b },
      { timeout: 0 }, { timeout: Float::NAN }, { timeout: "1" },
      { lwa_endpoint: "http://example.com" }, { lwa_endpoint: "https://secret@example.com" },
      { lwa_endpoint: "\xFF" }, { lwa_endpoint: "\xFF".b }].each do |options|
      error = assert_raises(ArgumentError) { sensitive_rescue { onboarding("http://127.0.0.1:1", **options) } }
      assert_nil(error.cause)
      refute_match(/sensitive-code|sensitive caller exception|secret\+&/, error.full_message)
    end
    instance = onboarding("http://127.0.0.1:1")
    [{ code: "" }, { code: " " }, { code: Object.new },
      { code: "\xFF" }, { code: "\xFF".b },
      { code: "code", redirect_uri: "relative" },
      { code: "code", redirect_uri: "https://example.com/#fragment" }, { code: "code", redirect_uri: false },
      { code: "code", redirect_uri: "\xFF" }, { code: "code", redirect_uri: "\xFF".b }].each do |options|
      error = assert_raises(ArgumentError) { sensitive_rescue { instance.exchange_authorization_code(**options) } }
      assert_nil(error.cause)
      refute_match(/sensitive-code|sensitive caller exception|secret\+&/, error.full_message)
    end
  end

  def test_redirect_is_not_followed_and_rejection_is_not_retried
    [302, 429, 500].each do |status|
      serve(handler: lambda { |socket, *|
        respond(socket, status: status, headers: [["Location", "http://127.0.0.1:1/sensitive"]], body: "sensitive")
      }) do |url|
        error = assert_raises(Peddler::Native::AuthenticationError) { onboarding(url).exchange_authorization_code(code: "code") }
        assert_equal(status, error.status)
      end
    end
  end

  def test_body_deadline_closes_socket_and_clears_cause
    serve(handler: lambda { |socket, *|
      socket.write("HTTP/1.1 200 OK\r\nContent-Length: 1000\r\n\r\n{")

      assert(socket.wait_readable(2))
      assert_nil(socket.read(1))
    }) do |url|
      error = assert_raises(Peddler::Native::TimeoutError) do
        sensitive_rescue { onboarding(url, timeout: 0.05).exchange_authorization_code(code: "code") }
      end
      assert_nil(error.cause)
    end
  end

  def test_interruption_closes_socket_and_client_recovers
    caller_error = begin
      sensitive_rescue { raise Peddler::Native::AuthenticationError.new("caller authentication failure", 403) }
    rescue Peddler::Native::AuthenticationError => error
      error
    end
    [Interrupt.new("caller interruption"), caller_error, nil].each do |interruption|
      started = Queue.new
      calls = Queue.new
      serve(count: 2, handler: lambda { |socket, *|
        if calls.empty?
          calls << true
          started << true

          assert(socket.wait_readable(2))
          assert_nil(socket.read(1))
        else
          respond(socket, body: token_body)
        end
      }) do |url|
        instance = onboarding(url)
        worker = Thread.new do
          instance.exchange_authorization_code(code: "code")
        rescue Interrupt, Peddler::Native::AuthenticationError => error
          error
        end
        Timeout.timeout(3) { started.pop }
        interruption ? worker.raise(interruption) : worker.kill

        assert(worker.join(2))
        if interruption
          assert_same(interruption, worker.value)
          if interruption.cause
            assert_same(interruption.cause, worker.value.cause)
          else
            assert_nil(worker.value.cause)
          end
        else
          assert_nil(worker.value)
        end

        assert_equal("onboard-refresh", instance.exchange_authorization_code(code: "new-code").refresh_token)
      ensure
        worker&.kill
        worker&.join
      end
    end
  end

  def test_simultaneous_calls_allow_ruby_progress_and_survive_gc
    arrived = Queue.new
    release = Queue.new
    serve(count: 2, handler: lambda { |socket, *|
      arrived << true
      release.pop
      respond(socket, body: token_body)
    }) do |url|
      instance = onboarding(url)
      workers = Array.new(2) { Thread.new { instance.exchange_authorization_code(code: "code") } }
      Timeout.timeout(3) { 2.times { arrived.pop } }
      instance = nil
      GC.start
      2.times { release << true }

      workers.each { |worker| assert_equal("onboard-refresh", worker.value.refresh_token) }
    ensure
      workers&.each(&:kill)
      workers&.each(&:join)
    end
  end

  def test_fork_guard_precedes_state_and_child_gc_is_safe
    instance = onboarding("http://127.0.0.1:1")
    reader, writer = IO.pipe
    pid = fork do
      reader.close
      begin
        sensitive_rescue { instance.exchange_authorization_code(code: "code") }
        writer.write("failed")
      rescue Peddler::Native::ForkError => error
        writer.write(error.cause.nil? ? "guarded" : "cause leaked")
      end
      instance = nil
      GC.start
      writer.close
      exit!(0)
    end
    writer.close

    assert_equal("guarded", Timeout.timeout(3) { reader.read })
    Process.wait(pid)
  ensure
    reader&.close
    writer&.close unless writer&.closed?
  end
end
# rubocop:enable Minitest/MultipleAssertions
