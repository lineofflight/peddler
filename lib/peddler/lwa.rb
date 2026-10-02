# frozen_string_literal: true

module Peddler
  # Exchanges an authorization code for Login with Amazon (LWA) tokens
  #
  # Application code owns consent, state verification and secure token storage. The client refreshes access tokens
  # itself.
  #
  # @see https://developer-docs.amazon.com/sp-api/docs/connecting-to-the-selling-partner-api
  class LWA
    DEFAULT_ENDPOINT = "https://api.amazon.com/auth/o2/token"

    class Tokens
      attr_reader :access_token, :refresh_token, :token_type, :expires_in

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

    def initialize(client_id: ENV["LWA_CLIENT_ID"], client_secret: ENV["LWA_CLIENT_SECRET"], timeout: 30,
      lwa_endpoint: DEFAULT_ENDPOINT)
      unless client_id && client_secret && text?(client_id) && text?(client_secret) && text?(lwa_endpoint) &&
          (timeout.is_a?(Integer) || timeout.is_a?(Float)) && timeout.finite? && timeout.positive?
        raise ArgumentError, "invalid authentication configuration"
      end

      @engine = Native.lwa_engine(client_id, client_secret, timeout, lwa_endpoint)
    end

    # Omit redirect_uri only for SDK-originated grants; otherwise provide the
    # exact URI used during authorization. Authorization codes aren't retried.
    def exchange_authorization_code(code:, redirect_uri: nil)
      unless text?(code) && (redirect_uri.nil? || text?(redirect_uri))
        raise ArgumentError, "invalid authentication configuration"
      end

      access_token, refresh_token, token_type, expires_in = @engine.exchange_authorization_code(code, redirect_uri)
      Tokens.new(access_token, refresh_token, token_type, expires_in)
    end

    def inspect = "#<Peddler::LWA>"
    alias_method :to_s, :inspect

    private

    def text?(value)
      value.is_a?(String) && value.valid_encoding? &&
        (value.encoding == Encoding::UTF_8 || value.ascii_only?)
    end
  end
end
