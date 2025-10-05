# frozen_string_literal: true

require "delegate"
require "forwardable"

require "peddler/error"

module Peddler
  # Wraps HTTP::Response to allow custom parsing
  #
  # Delegates all unimplemented methods to the wrapped HTTP::Response object.
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
    # @return [void]
    # @raise [Peddler::Error] if the response indicates an error
    def raise_for_status!
      return if status < 400

      error = Error.build(__getobj__)
      raise error || Error.new(status, __getobj__)
    end
  end
end
