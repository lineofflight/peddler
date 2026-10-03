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

    def test_sandbox_option_resolves_to_the_sandbox_endpoint
      options = { region: "eu-west-1", access_token: "token", sandbox: true }

      assert_equal("https://sandbox.sellingpartnerapi-eu.amazon.com", config(**options)["base_url"])
      assert_predicate(Client.new(**options), :sandbox?)
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
      client = Client.new(region: "eu-west-1", access_token: "token", sandbox: true)
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

    def test_sandbox_and_base_url_are_mutually_exclusive
      assert_raises(ArgumentError) { Client.new(base_url: "http://localhost:9001", access_token: "token", sandbox: true) }
      assert_raises(ArgumentError) { Client.new(base_url: "http://localhost:9001", access_token: "token").sandbox }
    end

    def test_unknown_region
      error = assert_raises(ArgumentError) { Client.new(region: "mars-north-1", access_token: "token") }

      assert_match(/not found/, error.message)
    end

    def test_rejects_invalid_base_urls
      ["localhost:9001", "not a url", "http://", "https://example.com/path", "https://user:secret@example.com"].each do |url|
        assert_raises(ArgumentError, url) { Client.new(base_url: url, access_token: "token") }
      end
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
      policy = config(region: "eu-west-1", access_token: "token", timeout: 5, retries: 2, retry_delay: 0.5,
        max_retry_delay: 10)

      assert_equal([5, 2, 0.5, 10], policy.values_at("timeout", "retries", "retry_delay", "max_retry_delay"))
      assert_equal(
        ["access_token", "base_url", "max_retry_delay", "retries", "retry_delay", "timeout", "user_agent"],
        policy.keys.sort,
      )
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
