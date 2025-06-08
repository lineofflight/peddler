# frozen_string_literal: true

require "helper"
require "peddler/token"

module Peddler
  class TokenTest < Minitest::Test
    include Configurable, Recordable

    def test_request
      response = Token.request(client_id:, client_secret:, refresh_token: refresh_token)
      access_token = response.parse["access_token"]

      assert(access_token)
    end

    def test_grantless_operations
      response = Token.request(client_id:, client_secret:, scope: scope)
      access_token = response.parse["access_token"]

      assert(access_token)
    end

    def test_token_error
      error = assert_raises(Errors::UnsupportedGrantType) do
        Token.request(client_id:, client_secret:)
      end

      refute_nil(error.response)
    end

    def test_obsolete_error_class
      assert(defined?(Token::Error))
      if Gem.loaded_specs["peddler"].version.segments.first >= 5
        flunk("Token::Error should have been removed in v5.0. Please delete it now.")
      end
    end

    def test_grant_type_with_code
      token = Token.new(code: "dummy_code")

      assert_equal("authorization_code", token.grant_type)
    end

    def test_grant_type_with_scope
      token = Token.new(scope: "dummy_scope")

      assert_equal("client_credentials", token.grant_type)
    end

    def test_grant_type_with_refresh_token
      token = Token.new(refresh_token: "dummy_refresh_token")

      assert_equal("refresh_token", token.grant_type)
    end

    def test_explicit_grant_type
      token = Token.new(grant_type: "let_me_in")

      assert_equal("let_me_in", token.grant_type)
    end

    private

    def scope
      "sellingpartnerapi::notifications"
    end
  end
end
