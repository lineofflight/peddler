# frozen_string_literal: true

module Peddler
  module Native
    private_constant :LwaEngine

    class LwaTokens
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

      def inspect = "#<Peddler::Native::LwaTokens [redacted]>"
      alias_method :to_s, :inspect
    end

    # Application code owns consent, state verification and secure token storage.
    class LWA
      DEFAULT_ENDPOINT = "https://api.amazon.com/auth/o2/token"

      def initialize(client_id:, client_secret:, timeout: 30, lwa_endpoint: DEFAULT_ENDPOINT)
        unless client_id.is_a?(String) && client_secret.is_a?(String) && lwa_endpoint.is_a?(String) &&
            (timeout.is_a?(Integer) || timeout.is_a?(Float)) && timeout.finite? && timeout.positive?
          raise ArgumentError, "invalid authentication configuration", cause: nil
        end

        @engine = LwaEngine.new(client_id, client_secret, timeout, lwa_endpoint)
      rescue ArgumentError, TransportError => error
        raise_sanitized(error)
      end

      # Omit redirect_uri only for SDK-originated grants; otherwise provide the
      # exact URI used during authorization. Authorization codes aren't retried.
      def exchange_authorization_code(code:, redirect_uri: nil)
        unless code.is_a?(String) && (redirect_uri.nil? || redirect_uri.is_a?(String))
          raise ArgumentError, "invalid authentication configuration", cause: nil
        end

        access_token, refresh_token, token_type, expires_in = @engine.exchange_authorization_code(code, redirect_uri)
        LwaTokens.new(access_token, refresh_token, token_type, expires_in)
      rescue ArgumentError, AuthenticationError, TransportError, ForkError => error
        raise_sanitized(error)
      end

      def inspect = "#<Peddler::Native::LWA>"
      alias_method :to_s, :inspect

      private

      def raise_sanitized(error)
        raise error unless error.instance_variable_defined?(:@peddler_native_lwa_error)

        fresh = if error.is_a?(AuthenticationError)
          error.class.new(error.message, error.status)
        else
          error.class.new(error.message)
        end
        backtrace = error.backtrace
        fresh.set_backtrace(backtrace) if backtrace
        raise fresh, cause: nil
      end
    end
  end
end
