# frozen_string_literal: true

require "json"
require "socket"
require_relative "errors"
require_relative "loader"
Peddler::Native::Loader.require_extension

module Peddler
  # Internals of the native layer. The public classes live at the root.
  module Native
    private_constant :Engine, :DocumentHandle, :UploadHandle, :LwaEngine

    class << self
      def engine(config)
        Engine.from_config(config)
      end

      def lwa_engine(client_id, client_secret, timeout, endpoint)
        LwaEngine.new(client_id, client_secret, timeout, endpoint)
      end

      # A token is a non-empty String of valid UTF-8, whether it is given or a source returns it. The error never
      # shows the value.
      def access_token(value)
        raise ArgumentError, "invalid access token" unless utf8_text?(value) && !value.empty?

        value
      end

      # The value, if it is a token source: anything that responds to call
      def token_source(value)
        value if value.respond_to?(:call)
      end

      # A String of valid UTF-8 as it is. Unlike valid_utf8_string?, it doesn't accept text another encoding could
      # convert.
      def utf8_text?(value)
        value.is_a?(String) && value.valid_encoding? && (value.encoding == Encoding::UTF_8 || value.ascii_only?)
      end

      def positive_seconds?(value)
        (value.is_a?(Integer) || value.is_a?(Float)) && value.finite? && value > 0
      end

      # A timeout as it is, or the error that names it. The native layer refuses what is left: one too short or
      # too long to keep.
      def timeout(value)
        raise ArgumentError, "timeout must be a positive number of seconds" unless positive_seconds?(value)

        value
      end

      # Whether the value is a String of valid UTF-8 with more than whitespace in it, as the core measures blank
      def present_text?(value)
        utf8_text?(value) && !value.match?(/\A[[:space:]]*\z/)
      end

      # Returns nil when the value can't be encoded. The generator's error quotes the value, which may be a
      # credential, so callers raise their own error outside this rescue, where it can't become the cause.
      def generate(value)
        JSON.generate(value)
      rescue JSON::GeneratorError, EncodingError, TypeError
        nil
      end

      # Identifies the gem to the Selling Partner API. LWA and signed URLs get the same without the host name.
      #
      # @see https://developer-docs.amazon.com/sp-api/docs/include-a-user-agent-header-in-all-requests
      def user_agent
        "Peddler/#{VERSION} (Language=Ruby; #{Socket.gethostname.gsub(/[^\x20-\x7E]/, "")})"
      end
    end

    # An engine may hold a token source, and a source may hold a refresh token, so nothing of it is shown.
    class Engine
      def inspect = "#<Peddler::Native::Engine>"
    end
  end
end

require_relative "arguments"
require_relative "pagination"
require_relative "apis"
require_relative "documents"
require_relative "workflows"
