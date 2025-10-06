# frozen_string_literal: true

require "helper"
require "peddler/lwa"

module Peddler
  class LWATest < Minitest::Test
    include Configurable, Recordable

    def test_request
      response = LWA.request(client_id:, client_secret:, refresh_token: refresh_token)
      parsed = response.parse

      assert_instance_of(Types::LWAToken, parsed)
      assert(parsed.access_token)
    end

    def test_request_token_type
      response = LWA.request(client_id:, client_secret:, refresh_token: refresh_token)

      assert_equal("bearer", response.parse.token_type)
    end

    def test_request_expires_in
      response = LWA.request(client_id:, client_secret:, refresh_token: refresh_token)

      assert(response.parse.expires_in)
    end

    def test_grantless_operations
      response = LWA.request(client_id:, client_secret:, scope: scope)
      parsed = response.parse

      assert_instance_of(Types::LWAToken, parsed)
      assert(parsed.access_token)
    end

    def test_grantless_operations_scope
      response = LWA.request(client_id:, client_secret:, scope: scope)

      assert_equal(scope, response.parse.scope)
    end

    def test_token_error
      error = assert_raises(Errors::UnsupportedGrantType) do
        LWA.request(client_id:, client_secret:)
      end

      refute_nil(error.response)
    end

    def test_grant_type_with_code
      lwa = LWA.new(code: "dummy_code")

      assert_equal("authorization_code", lwa.grant_type)
    end

    def test_grant_type_with_scope
      lwa = LWA.new(scope: "dummy_scope")

      assert_equal("client_credentials", lwa.grant_type)
    end

    def test_grant_type_with_refresh_token
      lwa = LWA.new(refresh_token: "dummy_refresh_token")

      assert_equal("refresh_token", lwa.grant_type)
    end

    def test_explicit_grant_type
      lwa = LWA.new(grant_type: "let_me_in")

      assert_equal("let_me_in", lwa.grant_type)
    end

    private

    def scope
      "sellingpartnerapi::notifications"
    end
  end
end
