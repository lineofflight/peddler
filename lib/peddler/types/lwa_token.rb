# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    # Login with Amazon (LWA) OAuth 2.0 token response
    #
    # This type represents the response from Amazon's token endpoint for all grant types:
    # - authorization_code: Returns access_token, refresh_token, token_type, expires_in
    # - refresh_token: Returns access_token, token_type, expires_in (refresh_token rarely included)
    # - client_credentials: Returns access_token, token_type, expires_in, scope
    #
    # @see https://developer-docs.amazon.com/sp-api/docs/connecting-to-the-selling-partner-api
    # @see https://developer.amazon.com/docs/login-with-amazon/documentation-overview.html
    LWAToken = Structure.new do
      # @return [String] The access token used to authenticate SP-API requests
      attribute(:access_token, String)

      # @return [String] The token type (always "bearer")
      attribute(:token_type, String)

      # @return [Integer] Number of seconds until the access token expires (typically 3600)
      attribute?(:expires_in, Integer)

      # @return [String, nil] The refresh token (present for authorization_code grant, rarely for refresh_token grant)
      attribute?(:refresh_token, String)

      # @return [String, nil] The scope granted (only present for client_credentials grant)
      attribute?(:scope, String)
    end
  end
end
