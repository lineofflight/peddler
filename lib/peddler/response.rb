# frozen_string_literal: true

require "delegate"
require "forwardable"

require "peddler/config"
require "peddler/error"

module Peddler
  # Wraps HTTP::Response to allow custom parsing
  class Response < SimpleDelegator
    extend Forwardable

    # @return [nil, #parse] Optional parser for the response
    attr_reader :parser

    # @!method dig(*key)
    #   Delegates to the Hash returned by {#to_h} to extract a nested
    #   value specified by the sequence of keys
    #
    #   @param [String] key one or more keys
    #   @see https://ruby-doc.org/3.4/Hash.html#method-i-dig
    def_delegator :to_h, :dig

    class << self
      # Wraps an HTTP response with error checking
      #
      # @param [HTTP::Response] response The HTTP response to wrap
      # @param [nil, #parse] parser Optional parser for the response
      # @return [Response] A wrapped response
      # @raise [Peddler::Error] if the response indicates an error
      def wrap(response, parser: nil)
        wrapped = new(response, parser:)
        wrapped.raise_for_status!
        wrapped
      end

      # @deprecated Use {.new} instead
      def decorate(...)
        warn("Response.decorate is deprecated and will be removed in v5.0. Use Response.new instead.", uplevel: 1)
        new(...)
      end
    end

    # Creates a new Response wrapper
    #
    # @param [HTTP::Response] http_response The HTTP response to wrap
    # @param [nil, #parse] parser Optional parser for the response
    def initialize(http_response, parser: nil)
      super(http_response)
      @parser = parser
    end

    # @return [Boolean] Whether this response can be parsed into typed objects
    def parsable?
      !parser.nil?
    end

    # Parses the response with typed Data objects
    #
    # @return [Object] Parsed response with type information, or Hash if no parser
    def parse
      parsable? ? parser.call.parse(to_h) : to_h
    end

    # Converts the response body to a Hash
    #
    # @return [Hash]
    def to_h
      __getobj__.parse
    end

    # Raises an error if the HTTP response status indicates failure
    #
    # @param raise_on_server_errors [Boolean] Whether to raise on 5xx errors (defaults to Peddler config)
    # @return [void]
    # @raise [Peddler::Error] if the response indicates an error
    def raise_for_status!(raise_on_server_errors: Peddler.raise_on_server_errors)
      return if status < 400

      # Client errors (4xx) always raise
      if status < 500
        error = Error.build(__getobj__)
        raise error || Error.new(status, __getobj__)
      # Server errors (5xx) - check configuration
      elsif raise_on_server_errors
        error = Error.build(__getobj__)
        raise error || Error.new(status, __getobj__)
      else
        # Emit deprecation warning for v4 behavior
        warn_about_server_error_handling
      end
    end

    private

    def warn_about_server_error_handling
      return if self.class.instance_variable_get(:@deprecation_warned)

      self.class.instance_variable_set(:@deprecation_warned, true)

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
end
