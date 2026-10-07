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

  def test_authorization_code_form_tokens_and_redaction
    calls = Queue.new
    serve(handler: lambda { |socket, _first, _headers, body|
      calls << body
      respond(socket, body: token_body)
    }) do |url|
      tokens = onboarding(url).exchange_authorization_code(code: "code+&λ", redirect_uri: "https://app.example/callback?state=a+b&x=雪")

      assert_equal(["onboard-access", "onboard-refresh", "bearer", 3600], [tokens.access_token, tokens.refresh_token, tokens.token_type, tokens.expires_in])
      assert_equal({ access_token: "onboard-access", refresh_token: "onboard-refresh", token_type: "bearer", expires_in: 3600, scope: nil }, tokens.to_h)
      refute_match(/onboard-access|onboard-refresh/, "#{tokens.inspect} #{tokens}")
    end

    assert_equal("grant_type=authorization_code&code=code%2B%26%CE%BB&client_id=id%2B%26%C3%A9&client_secret=secret%2B%26%E9%9B%AA&redirect_uri=https%3A%2F%2Fapp.example%2Fcallback%3Fstate%3Da%2Bb%26x%3D%E9%9B%AA", calls.pop)
  end

  def test_client_credentials_token
    reply = { access_token: "grantless", token_type: "bearer", expires_in: 3600, scope: "sellingpartnerapi::notifications" }
    serve(handler: ->(socket, *) { respond(socket, body: JSON.generate(reply)) }) do |url|
      tokens = onboarding(url).client_credentials(scope: "sellingpartnerapi::notifications")

      assert_equal("grantless", tokens.access_token)
      assert_nil(tokens.refresh_token)
      assert_equal("sellingpartnerapi::notifications", tokens.scope)
      assert_equal("sellingpartnerapi::notifications", tokens.to_h.fetch(:scope))
    end
  end

  def test_rejections_responses_and_arguments_are_sanitized
    named = JSON.generate(error: "invalid_client", error_description: "sensitive description for secret+&雪")
    serve(handler: ->(socket, *) { respond(socket, status: 401, body: named) }) do |url|
      error = assert_raises(Peddler::AuthenticationError) { onboarding(url).refresh(refresh_token: "sensitive-refresh") }

      assert_equal(["invalid_client", 401, "authentication rejected (401)"], [error.code, error.status, error.message])
      refute_match(/sensitive|description|secret\+&/, "#{error.message} #{error.inspect} #{error.full_message(highlight: false)}")
    end
    serve(handler: ->(socket, *) { respond(socket, body: token_body(token_type: "basic")) }) do |url|
      error = assert_raises(Peddler::AuthenticationError) { onboarding(url).exchange_authorization_code(code: "sensitive-code") }

      refute_match(/sensitive-code|onboard-access|onboard-refresh|secret\+&/, error.message)
    end
    instance = onboarding("http://127.0.0.1:1")
    [
      -> { onboarding("http://127.0.0.1:1", client_id: "") },
      -> { onboarding("http://127.0.0.1:1", client_secret: " ") },
      -> { onboarding("http://127.0.0.1:1", timeout: 0) },
      -> { onboarding("http://127.0.0.1:1", lwa_endpoint: "https://secret@example.com") },
      -> { instance.exchange_authorization_code(code: "") },
      -> { instance.refresh(refresh_token: nil) },
      -> { instance.client_credentials(scope: " ") },
    ].each do |call|
      error = assert_raises(ArgumentError, &call)

      refute_match(/secret\+&/, error.message)
    end
  end

  def test_a_bad_argument_of_a_grant_is_named_with_its_rule
    instance = onboarding("http://127.0.0.1:1")
    blank = "must be a UTF-8 String that is not blank"
    {
      -> { instance.refresh(refresh_token: nil) } => "refresh_token #{blank}",
      -> { instance.refresh(refresh_token: " ") } => "refresh_token #{blank}",
      -> { instance.client_credentials(scope: "") } => "scope #{blank}",
      -> { instance.client_credentials(scope: 123) } => "scope #{blank}",
      -> { instance.exchange_authorization_code(code: " ") } => "code #{blank}",
      -> { instance.exchange_authorization_code(code: "secret+&", redirect_uri: 123) } => "redirect_uri must be a UTF-8 String",
      -> { instance.token_source(refresh_token: " ") } => "refresh_token #{blank}",
      -> { instance.token_source(refresh_token: false) } => "refresh_token #{blank}",
      -> { instance.token_source(scope: 123) } => "scope #{blank}",
      -> { instance.token_source(scope: false) } => "scope #{blank}",
      -> { instance.token_source } => "provide either refresh_token or scope",
    }.each do |call, message|
      error = assert_raises(ArgumentError, &call)

      assert_equal(message, error.message)
    end
    assert_instance_of(Peddler::LWA::TokenSource, instance.token_source(scope: "sellingpartnerapi::notifications"))
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
    interruption = Interrupt.new("caller interruption")
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
        instance.refresh(refresh_token: "refresh")
      rescue Interrupt => error
        error
      end
      Timeout.timeout(3) { started.pop }
      worker.raise(interruption)

      assert(worker.join(2))
      assert_same(interruption, worker.value)
      assert_equal("onboard-refresh", instance.exchange_authorization_code(code: "new-code").refresh_token)
    ensure
      worker&.kill
      worker&.join
    end
  end
end
# rubocop:enable Minitest/MultipleAssertions
