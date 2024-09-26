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

    def test_bad_Token
      assert_raises(Token::Error) do
        Token.request(client_id:, client_secret:)
      end
    end

    private

    def scope
      "sellingpartnerapi::notifications"
    end
  end
end
