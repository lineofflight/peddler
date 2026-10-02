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
      rebased = []
      engine = client.instance_variable_get(:@engine)
      original = engine.method(:with_base_url)
      view = engine.stub(:with_base_url, ->(url) { (rebased << url) && original.call(url) }) { client.sandbox }

      assert_equal(["https://sandbox.sellingpartnerapi-eu.amazon.com"], rebased)
      refute_predicate(client, :sandbox?)
      assert_predicate(view, :sandbox?)
      assert_instance_of(Client, view)
      refute_same(client, view)
      assert_same(view, view.sandbox)
    end

    def test_restricted_views_keep_the_sandbox_setting
      client = Client.new(region: "eu-west-1", access_token: "token", sandbox: true)

      assert_predicate(client.restricted(resources: [{ method: "GET", path: "/orders/v0/orders" }]), :sandbox?)
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

    def test_refresh_token_defaults_the_application_credentials_from_the_environment
      with_env("LWA_CLIENT_ID" => "env-id", "LWA_CLIENT_SECRET" => "env-secret") do
        defaults = config(region: "eu-west-1", refresh_token: "refresh")

        assert_equal(["env-id", "env-secret", "refresh"], defaults.values_at("client_id", "client_secret", "refresh_token"))
        assert_equal("explicit-id", config(region: "eu-west-1", refresh_token: "refresh", client_id: "explicit-id")["client_id"])
      end
    end

    def test_scope_defaults_the_application_credentials_from_the_environment
      with_env("LWA_CLIENT_ID" => "env-id", "LWA_CLIENT_SECRET" => "env-secret") do
        grantless = config(region: "eu-west-1", scope: "sellingpartnerapi::notifications")

        assert_equal(["env-id", "env-secret"], grantless.values_at("client_id", "client_secret"))
        assert_equal("sellingpartnerapi::notifications", grantless["scope"])
      end
    end

    def test_access_token_ignores_the_environment
      with_env("LWA_CLIENT_ID" => "env-id", "LWA_CLIENT_SECRET" => "env-secret") do
        static = config(region: "eu-west-1", access_token: "token")

        assert_equal("token", static["access_token"])
        assert_nil(static["client_id"])
        assert_nil(static["client_secret"])
      end
    end

    def test_missing_or_conflicting_credentials
      with_env("LWA_CLIENT_ID" => nil, "LWA_CLIENT_SECRET" => nil) do
        [
          {},
          { refresh_token: "refresh" },
          { access_token: "token", refresh_token: "refresh" },
          { access_token: "token", client_id: "id" },
          { refresh_token: "refresh", scope: "scope", client_id: "id", client_secret: "secret" },
        ].each do |credentials|
          error = assert_raises(ArgumentError, credentials.inspect) { Client.new(region: "eu-west-1", **credentials) }

          refute_match(/token|refresh|secret/, error.message)
        end
      end
    end

    def test_construction_performs_no_network_access
      client = Client.new(region: "eu-west-1", client_id: "id", client_secret: "secret", refresh_token: "refresh")

      assert_respond_to(client, :orders_v0)
      assert_respond_to(client, :orders)
    end

    def test_inspect_shows_no_credentials
      client = Client.new(region: "eu-west-1", client_id: "app-id", client_secret: "app-secret", refresh_token: "seller-refresh")

      refute_match(/app-id|app-secret|seller-refresh/, client.inspect)
      refute_match(/app-id|app-secret|seller-refresh/, client.sandbox.inspect)
    end

    def test_keeps_policy_options
      policy = config(region: "eu-west-1", access_token: "token", timeout: 5, retries: 2, retry_delay: 0.5,
        max_retry_delay: 10, rate_limits: { "orders_v0.get_orders" => { rate: 0.5, burst: 1 } }, lwa_endpoint: "http://localhost:1")

      assert_equal([5, 2, 0.5, 10, "http://localhost:1"],
        policy.values_at("timeout", "retries", "retry_delay", "max_retry_delay", "lwa_endpoint"))
      assert_equal({ "orders_v0.get_orders" => { "rate" => 0.5, "burst" => 1 } }, policy["rate_limits"])
    end

    def test_lwa_defaults_the_application_credentials_from_the_environment
      with_env("LWA_CLIENT_ID" => "env-id", "LWA_CLIENT_SECRET" => "env-secret") do
        assert_instance_of(LWA, LWA.new)
        assert_respond_to(LWA.new, :exchange_authorization_code)
      end
      with_env("LWA_CLIENT_ID" => nil, "LWA_CLIENT_SECRET" => nil) do
        assert_raises(ArgumentError) { LWA.new }
      end
      refute_respond_to(LWA, :request)
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
