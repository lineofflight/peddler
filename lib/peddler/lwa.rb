# frozen_string_literal: true

require "http"

require "peddler/error"
require "peddler/response"
require "peddler/types/lwa_token"

module Peddler
  # Requests Login with Amazon (LWA) access tokens that authorize your application to make SP-API requests.
  #
  # Supports three OAuth 2.0 grant types:
  # - authorization_code: Exchange authorization code for refresh token (initial authorization)
  # - refresh_token: Exchange refresh token for access token (most common)
  # - client_credentials: Get access token for grantless operations (e.g., notifications)
  #
  # @see https://developer-docs.amazon.com/sp-api/docs/connecting-to-the-selling-partner-api
  class LWA
    URL = "https://api.amazon.com/auth/o2/token"

    attr_reader :client_id, :client_secret, :options

    class << self
      def request(...)
        new(...).request
      end
    end

    def initialize(client_id: ENV["LWA_CLIENT_ID"], client_secret: ENV["LWA_CLIENT_SECRET"], **options)
      @client_id = client_id
      @client_secret = client_secret
      @options = options
    end

    def request
      http_response = HTTP.post(URL, form: params)
      Response.wrap(http_response, parser: -> { Types::LWAToken })
    end

    def grant_type
      if options.key?(:grant_type)
        options[:grant_type]
      elsif options.key?(:refresh_token)
        "refresh_token"
      elsif options.key?(:scope)
        "client_credentials"
      elsif options.key?(:code)
        "authorization_code"
      end
    end

    private

    def params
      {
        grant_type: grant_type,
        client_id: client_id,
        client_secret: client_secret,
      }.compact.merge(options)
    end
  end
end
