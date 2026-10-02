# frozen_string_literal: true

require_relative "test_helper"

# Each test checks one protocol or lifecycle interaction.
# rubocop:disable Minitest/MultipleAssertions
class LwaTest < NativeTest
  def token_body(**overrides)
    JSON.generate({ access_token: "onboard-access", refresh_token: "onboard-refresh", token_type: "bearer", expires_in: 3600 }.merge(overrides))
  end

  def onboarding(url, **options)
    Peddler::LWA.new(client_id: "id+&é", client_secret: "secret+&雪", lwa_endpoint: url, **options)
  end

  # Each grant as a call on an instance, to check a rule on all three.
  GRANTS = {
    exchange_authorization_code: ->(instance) { instance.exchange_authorization_code(code: "sensitive-code") },
    refresh: ->(instance) { instance.refresh(refresh_token: "sensitive-refresh") },
    client_credentials: ->(instance) { instance.client_credentials(scope: "sellingpartnerapi::notifications") },
  }.freeze

  def test_authorization_code_form_and_refresh_integration
    assert(Peddler.const_defined?(:LWA), "native onboarding is missing")
    calls = Queue.new
    refreshed = JSON.generate(access_token: "refreshed-access", token_type: "bearer", expires_in: 3600)
    serve(count: 2, handler: lambda { |socket, first, headers, body|
      assert_equal("POST", first[0])
      assert_equal("application/x-www-form-urlencoded", headers["content-type"])
      refute(headers.key?("x-amz-access-token"))
      refute(headers.key?("x-amz-date"))
      assert_equal(hostless_user_agent, headers["user-agent"])
      refute(headers.key?("authorization"))
      refute_equal("application/json", headers["accept"])
      calls << body
      respond(socket, body: calls.size == 1 ? token_body : refreshed)
    }) do |url|
      tokens = onboarding(url).exchange_authorization_code(code: "code+&λ", redirect_uri: "https://app.example/callback?state=a+b&x=雪")

      assert_equal("onboard-access", tokens.access_token)
      assert_equal("onboard-refresh", tokens.refresh_token)
      assert_equal("bearer", tokens.token_type)
      assert_equal(3600, tokens.expires_in)
      assert_equal({ access_token: "onboard-access", refresh_token: "onboard-refresh", token_type: "bearer", expires_in: 3600 }, tokens.to_h)
      refute_match(/onboard-access|onboard-refresh/, "#{tokens.inspect} #{tokens}")
      fresh = onboarding(url).refresh(refresh_token: tokens.refresh_token)

      assert_equal(["refreshed-access", nil, "bearer", 3600], fresh.to_h.values_at(:access_token, :refresh_token, :token_type, :expires_in))
      refute_match(/refreshed-access/, "#{fresh.inspect} #{fresh}")
      serve(handler: lambda { |socket, _first, headers, _body|
        assert_equal("refreshed-access", headers["x-amz-access-token"])
        respond(socket)
      }) do |api|
        assert_equal(200, Peddler::Client.new(base_url: api, access_token: fresh.access_token).request("GET", "/").status)
      end
    end

    assert_equal("grant_type=authorization_code&code=code%2B%26%CE%BB&client_id=id%2B%26%C3%A9&client_secret=secret%2B%26%E9%9B%AA&redirect_uri=https%3A%2F%2Fapp.example%2Fcallback%3Fstate%3Da%2Bb%26x%3D%E9%9B%AA", calls.pop)
    assert_equal("grant_type=refresh_token&client_id=id%2B%26%C3%A9&client_secret=secret%2B%26%E9%9B%AA&refresh_token=onboard-refresh", calls.pop)
  end

  def test_refresh_keeps_nothing_and_asks_lwa_every_time
    calls = Queue.new
    serve(count: 2, handler: lambda { |socket, _first, _headers, body|
      calls << body
      respond(socket, body: token_body(access_token: "access-#{calls.size}"))
    }) do |url|
      instance = onboarding(url)

      assert_equal("access-1", instance.refresh(refresh_token: "refresh+&λ").access_token)
      assert_equal("access-2", instance.refresh(refresh_token: "refresh+&λ").access_token)
    end

    2.times do
      assert_equal("grant_type=refresh_token&client_id=id%2B%26%C3%A9&client_secret=secret%2B%26%E9%9B%AA&refresh_token=refresh%2B%26%CE%BB", calls.pop)
    end
  end

  def test_client_credentials_form_and_token_feeds_a_client
    serve(handler: lambda { |socket, first, headers, body|
      assert_equal("POST", first[0])
      assert_equal(hostless_user_agent, headers["user-agent"])
      assert_equal("grant_type=client_credentials&client_id=grantless-id&client_secret=grantless-secret&scope=sellingpartnerapi%3A%3Anotifications", body)
      respond(socket, body: JSON.generate(access_token: "grantless", token_type: "bearer", expires_in: 3600))
    }) do |lwa|
      tokens = Peddler::LWA.new(client_id: "grantless-id", client_secret: "grantless-secret", lwa_endpoint: lwa)
        .client_credentials(scope: "sellingpartnerapi::notifications")

      assert_equal("grantless", tokens.access_token)
      assert_nil(tokens.refresh_token)
      serve(count: 2, handler: lambda { |socket, _first, headers, _body|
        assert_equal("grantless", headers["x-amz-access-token"])
        respond(socket)
      }) do |url|
        instance = Peddler::Client.new(base_url: url, access_token: tokens.access_token)

        assert_equal(200, instance.notifications_v1.get_destinations.status)
        assert_equal(200, instance.request("GET", "/").status)
      end
    end
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
        error = assert_raises(Peddler::AuthenticationError) { onboarding(url).exchange_authorization_code(code: "sensitive-code") }
        refute_match(/sensitive-code|onboard-access|onboard-refresh|secret\+&/, error.message)
      end
    end
    # The other grants need no refresh token back, and validate the rest the same way.
    unsent = JSON.generate(valid.reject { |name, _| name == "refresh_token" })
    invalid = [valid.reject { |name, _| name == "access_token" }, valid.merge("token_type" => "basic"), valid.merge("expires_in" => 0)]
    GRANTS.except(:exchange_authorization_code).each_value do |grant|
      serve(handler: ->(socket, *) { respond(socket, body: unsent) }) do |url|
        assert_nil(grant.call(onboarding(url)).refresh_token)
      end
      invalid.each do |data|
        serve(handler: ->(socket, *) { respond(socket, body: JSON.generate(data)) }) do |url|
          error = assert_raises(Peddler::AuthenticationError) { grant.call(onboarding(url)) }
          refute_match(/sensitive-refresh|onboard-access|onboard-refresh|secret\+&/, error.message)
        end
      end
    end
  end

  def sensitive_rescue
    raise "sensitive caller exception"
  rescue RuntimeError
    yield
  end

  def test_rejections_and_validation_are_sanitized
    GRANTS.each_value do |grant|
      serve(handler: ->(socket, *) { respond(socket, status: 401, body: "sensitive-code sensitive-refresh secret+&雪") }) do |url|
        error = assert_raises(Peddler::AuthenticationError) { grant.call(onboarding(url)) }
        assert_equal(401, error.status)
        refute_match(/sensitive-code|sensitive-refresh|secret\+&/, error.message)
      end
    end
    [{ client_id: "" }, { client_secret: " " }, { client_id: Object.new },
      { client_id: "\xFF" }, { client_id: "\xFF".b },
      { client_secret: "\xFF" }, { client_secret: "\xFF".b },
      { timeout: 0 }, { timeout: Float::NAN }, { timeout: "1" },
      { lwa_endpoint: "http://example.com" }, { lwa_endpoint: "https://secret@example.com" },
      { lwa_endpoint: "\xFF" }, { lwa_endpoint: "\xFF".b }].each do |options|
      error = assert_raises(ArgumentError) { onboarding("http://127.0.0.1:1", **options) }
      refute_match(/secret\+&/, error.message)
    end
    instance = onboarding("http://127.0.0.1:1")
    [{ code: "" }, { code: " " }, { code: Object.new },
      { code: "\xFF" }, { code: "\xFF".b },
      { code: "code", redirect_uri: "relative" },
      { code: "code", redirect_uri: "https://example.com/#fragment" }, { code: "code", redirect_uri: false },
      { code: "code", redirect_uri: "\xFF" }, { code: "code", redirect_uri: "\xFF".b }].each do |options|
      error = assert_raises(ArgumentError) { instance.exchange_authorization_code(**options) }
      refute_match(/secret\+&/, error.message)
    end
    ["", " ", Object.new, nil, "sensitive-\xFF", "sensitive-\xFF".b].each do |value|
      [-> { instance.refresh(refresh_token: value) }, -> { instance.client_credentials(scope: value) }].each do |grant|
        error = assert_raises(ArgumentError, value.inspect, &grant)
        refute_match(/sensitive|secret\+&/, error.message)
      end
    end
  end

  def test_rejection_names_the_problem_and_shows_nothing_else
    named = JSON.generate(error: "invalid_client", error_description: "sensitive description for secret+&雪")
    GRANTS.each_value do |grant|
      serve(handler: ->(socket, *) { respond(socket, status: 401, body: named) }) do |url|
        error = assert_raises(Peddler::AuthenticationError) { grant.call(onboarding(url)) }

        assert_equal("invalid_client", error.code)
        assert_equal(401, error.status)
        assert_equal("authentication rejected (401)", error.message)
        refute_match(/sensitive|description|secret\+&/, "#{error.message} #{error.inspect} #{error.full_message(highlight: false)}")
      end
    end
    # Only a short lowercase identifier is passed on; anything else is not a code Amazon documents.
    [{ error: "Invalid_Client" }, { error: "invalid client" }, { error: "x" * 41 }, { error: "" }, { error: 401 },
      { error: ["invalid_client"] }, { error_description: "sensitive" }, { "errors" => "invalid_client" }].each do |reply|
      serve(handler: ->(socket, *) { respond(socket, status: 400, body: JSON.generate(reply)) }) do |url|
        error = assert_raises(Peddler::AuthenticationError) { onboarding(url).refresh(refresh_token: "refresh") }

        assert_nil(error.code, reply.inspect)
        assert_equal(400, error.status)
        refute_match(/sensitive|Invalid_Client|xxxx/, "#{error.message} #{error.inspect}")
      end
    end
    ["sensitive not json", "", "x" * (64 * 1024 + 1)].each do |body|
      serve(handler: ->(socket, *) { respond(socket, status: 403, body: body) }) do |url|
        error = assert_raises(Peddler::AuthenticationError) { onboarding(url).client_credentials(scope: "scope") }

        assert_nil(error.code)
        assert_equal(403, error.status)
      end
    end

    assert_equal(["invalid_grant", 400], Peddler::AuthenticationError.new("rejected", 400, code: "invalid_grant").then { |e| [e.code, e.status] })
    assert_nil(Peddler::AuthenticationError.new("failed").code)
  end

  def test_redirect_is_not_followed_and_rejection_is_not_retried
    GRANTS.each_value do |grant|
      [302, 429, 500].each do |status|
        serve(handler: lambda { |socket, *|
          respond(socket, status: status, headers: [["Location", "http://127.0.0.1:1/sensitive"]], body: "sensitive")
        }) do |url|
          error = assert_raises(Peddler::AuthenticationError) { grant.call(onboarding(url)) }
          assert_equal(status, error.status)
        end
      end
    end
  end

  def test_body_deadline_closes_socket
    serve(handler: lambda { |socket, *|
      socket.write("HTTP/1.1 200 OK\r\nContent-Length: 1000\r\n\r\n{")

      assert(socket.wait_readable(2))
      assert_nil(socket.read(1))
    }) do |url|
      assert_raises(Peddler::TimeoutError) do
        onboarding(url, timeout: 0.05).exchange_authorization_code(code: "code")
      end
    end
  end

  def test_interruption_closes_socket_and_client_recovers
    caller_error = begin
      sensitive_rescue { raise Peddler::AuthenticationError.new("caller authentication failure", 403) }
    rescue Peddler::AuthenticationError => error
      error
    end
    [Interrupt.new("caller interruption"), caller_error, nil].zip(GRANTS.values).each do |interruption, grant|
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
          grant.call(instance)
        rescue Interrupt, Peddler::AuthenticationError => error
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
      GRANTS.each_value do |grant|
        grant.call(instance)
        writer.write("failed")
      rescue Peddler::ForkError
        writer.write("guarded")
      end
      instance = nil
      GC.start
      writer.close
      exit!(0)
    end
    writer.close

    assert_equal("guarded" * 3, Timeout.timeout(3) { reader.read })
    Process.wait(pid)
  ensure
    reader&.close
    writer&.close unless writer&.closed?
  end
end
# rubocop:enable Minitest/MultipleAssertions
