# frozen_string_literal: true

require "helper"
require "peddler/access_token"

module Peddler
  class AccessTokenTest < Minitest::Test
    def test_request
      token = AccessToken.new(client_id:, client_secret:, refresh_token: refresh_token).request

      assert(token)
    end

    def test_grantless_operations
      token = AccessToken.request(client_id:, client_secret:, scope: scope)

      assert(token)
    end

    def test_refresh_token_or_scope_validation
      assert_raises(ArgumentError) do
        AccessToken.request(client_id:, client_secret:)
      end

      assert_raises(ArgumentError) do
        AccessToken.request(client_id:, client_secret:, refresh_token: refresh_token, scope: scope)
      end
    end

    def test_lwa_credentials_validation
      assert_raises(ArgumentError) do
        AccessToken.request(client_id: nil, client_secret: "123", scope: scope)
      end

      assert_raises(ArgumentError) do
        AccessToken.request(client_id: "123", client_secret: nil, scope: scope)
      end
    end

    private

    def scope
      "sellingpartnerapi::notifications"
    end
  end
end
