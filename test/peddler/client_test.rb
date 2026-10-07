# frozen_string_literal: true

require "helper"

# Construction tests assert several parts of one configuration.
# rubocop:disable Minitest/MultipleAssertions
module Peddler
  class ClientTest < Minitest::Test
    def test_region_resolves_to_the_production_endpoint
      assert_equal("https://sellingpartnerapi-eu.amazon.com", config(region: "eu-west-1", access_token: "token")["base_url"])
      assert_equal("https://sellingpartnerapi-na.amazon.com", config(region: "us-east-1", access_token: "token")["base_url"])
      assert_equal("https://sellingpartnerapi-fe.amazon.com", config(region: "us-west-2", access_token: "token")["base_url"])
    end

    def test_sandbox_returns_a_view_of_the_same_client
      client = Client.new(region: "eu-west-1", access_token: "token")
      view = client.sandbox

      refute_predicate(client, :sandbox?)
      assert_predicate(view, :sandbox?)
      assert_instance_of(Client, view)
      refute_same(client, view)
      assert_same(view, view.sandbox)
      assert_same(view, client.sandbox)
    end

    def test_token_views_keep_the_region_and_the_sandbox_setting
      client = Client.new(region: "eu-west-1", access_token: "token").sandbox
      view = client.with_access_token("other")

      assert_instance_of(Client, view)
      refute_same(client, view)
      assert_predicate(view, :sandbox?)
      assert_same(view, view.sandbox)

      production = Client.new(region: "eu-west-1", access_token: "token").with_access_token("other")

      refute_predicate(production, :sandbox?)
      assert_predicate(production.sandbox, :sandbox?)
    end

    def test_base_url_overrides_the_destination
      assert_equal("http://localhost:9001", config(base_url: "http://localhost:9001", access_token: "token")["base_url"])
      refute_predicate(Client.new(base_url: "http://localhost:9001", access_token: "token"), :sandbox?)
    end

    def test_region_and_base_url_are_mutually_exclusive
      assert_raises(ArgumentError) { Client.new(region: "eu-west-1", base_url: "http://localhost:9001", access_token: "token") }
      assert_raises(ArgumentError) { Client.new(access_token: "token") }
    end

    def test_a_custom_base_url_has_no_sandbox
      assert_raises(ArgumentError) { Client.new(base_url: "http://localhost:9001", access_token: "token").sandbox }
    end

    def test_unknown_region
      ["mars-north-1", :"eu-west-1", false].each do |region|
        error = assert_raises(ArgumentError, region.inspect) { Client.new(region: region, access_token: "token") }

        assert_equal("region must be one of us-east-1, us-west-2, eu-west-1", error.message)
      end
    end

    def test_rejects_invalid_base_urls
      [
        "localhost:9001",
        "not a url",
        "http://",
        "http://example.com",
        "https://example.com/path",
        "https://example.com?key=secret",
        "https://user:secret@example.com",
        123,
      ].each do |url|
        error = assert_raises(ArgumentError, url.inspect) { Client.new(base_url: url, access_token: "token") }

        assert_equal(
          "base_url must be an origin (https, or http on a loopback host) without credentials, a path or a query",
          error.message,
        )
      end
    end

    def test_a_bad_timeout_or_retries_is_named_with_its_rule
      [0, -1, "30", nil, Float::NAN, Float::INFINITY, 1e-12, 1e30, 10**400].each do |timeout|
        error = assert_raises(ArgumentError, timeout.inspect) { Client.new(region: "eu-west-1", access_token: "token", timeout: timeout) }

        assert_equal("timeout must be a positive number of seconds", error.message)
      end
      [11, -1, 1.5, "3", nil].each do |retries|
        error = assert_raises(ArgumentError, retries.inspect) { Client.new(region: "eu-west-1", access_token: "token", retries: retries) }

        assert_equal("retries must be an Integer between 0 and 10", error.message)
      end
      assert_instance_of(Client, Client.new(region: "eu-west-1", access_token: "token", timeout: 0.5, retries: 10))
    end

    def test_requires_an_access_token
      error = assert_raises(ArgumentError) { Client.new(region: "eu-west-1") }

      assert_match(/access_token/, error.message)
      [nil, "", " ", 1].each do |token|
        assert_raises(ArgumentError, token.inspect) { Client.new(region: "eu-west-1", access_token: token) }
      end
    end

    def test_accepts_a_token_source_and_does_not_call_it_until_a_request
      source = -> { raise "asked too early" }
      client = Client.new(region: "eu-west-1", access_token: source)

      assert_instance_of(Client, client.sandbox)
      assert_instance_of(Client, client.with_access_token("token").with_access_token(source))
      assert_respond_to(client, :orders)
      assert_nil(config(region: "eu-west-1", access_token: source)["access_token"])
    end

    def test_inspect_shows_no_credentials
      client = Client.new(region: "eu-west-1", access_token: "seller-access")

      [client, client.sandbox, client.with_access_token("other-access")].each do |instance|
        refute_match(/seller-access|other-access/, instance.inspect)
      end
    end

    def test_keeps_policy_options_and_nothing_else
      policy = config(region: "eu-west-1", access_token: "token", timeout: 5, retries: 2)

      assert_equal([5, 2], policy.values_at("timeout", "retries"))
      assert_equal(["access_token", "base_url", "retries", "timeout", "user_agent"], policy.keys.sort)
    end

    def test_lwa_defaults_the_application_credentials_from_the_environment
      with_env("LWA_CLIENT_ID" => "env-id", "LWA_CLIENT_SECRET" => "env-secret") do
        assert_instance_of(LWA, LWA.new)
        [:refresh, :client_credentials, :exchange_authorization_code].each { |grant| assert_respond_to(LWA.new, grant) }
      end

      refute_respond_to(LWA, :request)
    end

    def test_lwa_names_the_missing_application_credential
      with_env("LWA_CLIENT_ID" => nil, "LWA_CLIENT_SECRET" => nil) do
        error = assert_raises(ArgumentError) { LWA.new }

        assert_match(/client_id.*LWA_CLIENT_ID/, error.message)
        error = assert_raises(ArgumentError) { LWA.new(client_id: "app-id") }

        assert_match(/client_secret.*LWA_CLIENT_SECRET/, error.message)
        refute_match(/app-id/, error.message)
      end
      with_env("LWA_CLIENT_ID" => "", "LWA_CLIENT_SECRET" => "env-secret") do
        error = assert_raises(ArgumentError) { LWA.new }

        assert_match(/LWA_CLIENT_ID/, error.message)
        refute_match(/env-secret/, error.message)
      end
    end

    def test_lwa_names_the_option_it_refuses_with_its_rule
      {
        { client_id: " " } => "client_id must be a UTF-8 String that is not blank",
        { client_secret: 123 } => "client_secret must be a UTF-8 String that is not blank",
        { timeout: 0 } => "timeout must be a positive number of seconds",
        { timeout: 1e30 } => "timeout must be a positive number of seconds",
        { timeout: 10**400 } => "timeout must be a positive number of seconds",
        { lwa_endpoint: 123 } => "lwa_endpoint must be a UTF-8 String",
        { lwa_endpoint: "http://example.com/token" } => "lwa_endpoint must be a URL (https, or http on a loopback host) without credentials or a query",
        { lwa_endpoint: "https://user:secret@example.com/token" } => "lwa_endpoint must be a URL (https, or http on a loopback host) without credentials or a query",
        { lwa_endpoint: "https://example.com/token?key=secret" } => "lwa_endpoint must be a URL (https, or http on a loopback host) without credentials or a query",
      }.each do |options, message|
        error = assert_raises(ArgumentError, options.inspect) { LWA.new(client_id: "id", client_secret: "secret", **options) }

        assert_equal(message, error.message)
      end
      assert_instance_of(LWA, LWA.new(client_id: "id", client_secret: "secret", lwa_endpoint: "http://localhost:9001/token"))
    end

    private

    # The configuration the client hands to the native engine
    def config(**options)
      captured = nil
      original = Native.method(:engine)
      Native.stub(:engine, ->(json) { original.call(captured = json) }) { Client.new(**options) }

      JSON.parse(captured)
    end

    def with_env(values)
      saved = values.to_h { |key, _| [key, ENV[key]] }
      values.each { |key, value| ENV[key] = value }
      yield
    ensure
      saved.each { |key, value| ENV[key] = value }
    end
  end
end
# rubocop:enable Minitest/MultipleAssertions
