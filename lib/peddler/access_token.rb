# frozen_string_literal: true

require "http"

module Peddler
  # Requests a Login with Amazon (LWA) access token that authorizes your application to take actions on behalf of a
  # selling partner. An LWA access token expires one hour after it is issued.
  #
  # @see https://developer-docs.amazon.com/sp-api/docs/connecting-to-the-selling-partner-api
  class AccessToken
    URL = "https://api.amazon.com/auth/o2/token"

    attr_reader :client_id, :client_secret, :refresh_token, :scope

    # @param client_id [String]
    # @param client_secret [String]
    # @param refresh_token [String]
    # @param scope [String]
    def initialize(client_id, client_secret, refresh_token: nil, scope: nil)
      @client_id = client_id
      @client_secret = client_secret
      @refresh_token = refresh_token
      @scope = scope

      validate_exclusive_token_or_scope
    end

    def request
      response = HTTP.post(URL, form: params)
      response.parse.fetch("access_token")
    end

    private

    def validate_exclusive_token_or_scope
      if @refresh_token.nil? == @scope.nil?
        raise ArgumentError, "Provide either refresh_token or scope, not both."
      end
    end

    def params
      {
        grant_type: grant_type,
        refresh_token: refresh_token,
        scope: scope,
        client_id: client_id,
        client_secret: client_secret,
      }.compact
    end

    def grant_type
      scope ? "client_credentials" : "refresh_token"
    end
  end
end
