# frozen_string_literal: true

require "helper"
require "peddler/access_token"

module Peddler
  class AccessTokenTest < Minitest::Test
    def test_request
      token = AccessToken.new(client_id, client_secret, refresh_token: refresh_token)

      assert(token.request)
    end

    def test_grantless
      token = AccessToken.new(client_id, client_secret, scope: scope)

      assert(token.request)
    end

    def test_validation
      assert_raises(ArgumentError) do
        AccessToken.new(client_id, client_secret)
      end

      assert_raises(ArgumentError) do
        AccessToken.new(client_id, client_secret, refresh_token: refresh_token, scope: scope)
      end
    end

    private

    def scope
      "sellingpartnerapi::notifications"
    end
  end
end
