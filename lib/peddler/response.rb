# frozen_string_literal: true

require "delegate"
require "forwardable"

require "peddler/config"
require "peddler/error"

module Peddler
  # Wraps HTTP::Response to allow custom parsing
  class Response < SimpleDelegator
    extend Forwardable

    # @!method dig(*key)
    #   Delegates to the Hash returned by {ResponseDecorator#to_h} to extract a nested
    #   value specified by the sequence of keys
    #
    #   @param [String] key one or more keys
    #   @see https://ruby-doc.org/core/Hash.html#method-i-dig
    def_delegator :to_h, :dig

    class << self
      # Wraps an HTTP::Response with parsing capabilities
      #
      # @param [HTTP::Response] response
      # @param [nil, #call] parser (if any)
      # @return [Response]
      # @raise [Error] if response status indicates an error (>= 400)
      def wrap(response, parser: nil)
        # Check for HTTP errors and raise custom Peddler errors
        if response.status >= 400
          # Client errors (4xx) always raise
          if response.status < 500
            error = Error.build(response)
            raise error || Error.new(response.status, response)
          # Server errors (5xx) - check configuration
          elsif Peddler.raise_on_server_errors
            error = Error.build(response)
            raise error || Error.new(response.status, response)
          else
            # Emit deprecation warning for v4 behavior
            warn_about_server_error_handling
          end
        end

        new(response).tap do |wrapper|
          wrapper.parser = parser
        end
      end

      # @deprecated Use {.wrap} instead
      def decorate(...)
        warn("Response.decorate is deprecated and will be removed in v5.0. Use Response.wrap instead.", uplevel: 1)
        wrap(...)
      end

      private

      def warn_about_server_error_handling
        return if @deprecation_warned

        @deprecation_warned = true

        warn(<<~MSG)
          [DEPRECATION] Peddler v4 behavior: Server errors (5xx) are returning response objects instead of raising exceptions.
          This behavior is deprecated and will change in Peddler v5.0.

          To adopt the new behavior now and silence this warning:

            Peddler.configure do |config|
              config.raise_on_server_errors = true
            end

          For more information, see: https://github.com/hakanensari/peddler/blob/main/CHANGELOG.md
        MSG
      end
    end

    # @return [#call]
    attr_accessor :parser

    def parse
      parser ? parser.call(__getobj__) : __getobj__.parse
    end

    # Converts the response body to a Hash
    #
    # @return [Hash]
    def to_h
      (parser && parser.respond_to?(:to_h) ? parser : parse).to_h
    end
  end
end
