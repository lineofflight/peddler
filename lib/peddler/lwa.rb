# frozen_string_literal: true

module Peddler
  # Requests Login with Amazon (LWA) tokens
  #
  # Every grant makes one request and keeps nothing. Application code owns consent, state verification, token
  # storage and when to ask for a new access token; {#token_source} is an optional in-process helper for the last. A rejection raises {Peddler::AuthenticationError}, whose `code`
  # is what Amazon names as the problem, such as "invalid_client" or "invalid_grant".
  #
  # @example
  #   lwa = Peddler::LWA.new
  #   tokens = lwa.refresh(refresh_token: seller.refresh_token)
  #   Rails.cache.write(key, tokens.access_token, expires_in: tokens.expires_in)
  # @see https://developer-docs.amazon.com/sp-api/docs/connecting-to-the-selling-partner-api
  class LWA
    DEFAULT_ENDPOINT = "https://api.amazon.com/auth/o2/token"

    class Tokens
      # @return [String, nil] nil when LWA sends none, as for a grantless token
      attr_reader :refresh_token

      attr_reader :access_token, :token_type, :expires_in

      def initialize(access_token, refresh_token, token_type, expires_in)
        @access_token = access_token
        @refresh_token = refresh_token
        @token_type = token_type
        @expires_in = expires_in
      end

      def to_h
        { access_token: access_token, refresh_token: refresh_token, token_type: token_type, expires_in: expires_in }
      end

      def inspect = "#<Peddler::LWA::Tokens [redacted]>"
      alias_method :to_s, :inspect
    end

    # @param [String] client_id defaults to LWA_CLIENT_ID in the environment
    # @param [String] client_secret defaults to LWA_CLIENT_SECRET in the environment
    def initialize(client_id: ENV["LWA_CLIENT_ID"], client_secret: ENV["LWA_CLIENT_SECRET"], timeout: 30,
      lwa_endpoint: DEFAULT_ENDPOINT)
      raise ArgumentError, "missing client_id: pass client_id: or set LWA_CLIENT_ID" unless client_id && client_id != ""
      unless client_secret && client_secret != ""
        raise ArgumentError, "missing client_secret: pass client_secret: or set LWA_CLIENT_SECRET"
      end
      unless Native.utf8_text?(client_id) && Native.utf8_text?(client_secret) && Native.utf8_text?(lwa_endpoint) &&
          Native.positive_seconds?(timeout)
        raise ArgumentError, "invalid authentication configuration"
      end

      @engine = Native.lwa_engine(client_id, client_secret, timeout, lwa_endpoint)
    end

    # Requests an access token for a seller
    #
    # @return [Tokens]
    def refresh(refresh_token:)
      raise ArgumentError, "invalid authentication configuration" unless Native.utf8_text?(refresh_token)

      tokens(@engine.refresh(refresh_token))
    end

    # Requests an access token for grantless operations
    #
    # @see https://developer-docs.amazon.com/sp-api/docs/grantless-operations
    # @return [Tokens]
    def client_credentials(scope:)
      raise ArgumentError, "invalid authentication configuration" unless Native.utf8_text?(scope)

      tokens(@engine.client_credentials(scope))
    end

    # An optional source of access tokens that keeps one in this process and refreshes it shortly before it expires
    #
    # @example
    #   source = Peddler::LWA.new.token_source(refresh_token: seller.refresh_token)
    #   client = Peddler::Client.new(region: "us-east-1", access_token: source)
    # @param [String] refresh_token a seller's refresh token, or
    # @param [String] scope the scope of grantless operations
    # @return [Peddler::LWA::TokenSource]
    def token_source(refresh_token: nil, scope: nil)
      raise ArgumentError, "provide either refresh_token or scope" unless refresh_token.nil? ^ scope.nil?

      value = refresh_token || scope
      raise ArgumentError, "invalid authentication configuration" unless value && Native.utf8_text?(value) && !value.strip.empty?

      refresh_token ? TokenSource.new { refresh(refresh_token: value) } : TokenSource.new { client_credentials(scope: value) }
    end

    # Omit redirect_uri only for SDK-originated grants; otherwise provide the
    # exact URI used during authorization. Authorization codes aren't retried.
    #
    # @return [Tokens]
    def exchange_authorization_code(code:, redirect_uri: nil)
      unless Native.utf8_text?(code) && (redirect_uri.nil? || Native.utf8_text?(redirect_uri))
        raise ArgumentError, "invalid authentication configuration"
      end

      tokens(@engine.exchange_authorization_code(code, redirect_uri))
    end

    def inspect = "#<Peddler::LWA>"
    alias_method :to_s, :inspect

    private

    def tokens(parts)
      access_token, refresh_token, token_type, expires_in = parts
      Tokens.new(access_token, refresh_token, token_type, expires_in)
    end
  end
end
