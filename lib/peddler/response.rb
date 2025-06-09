# frozen_string_literal: true

require "delegate"
require "forwardable"

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
      def wrap(response, parser: nil)
        new(response).tap do |wrapper|
          wrapper.parser = parser
        end
      end

      # @deprecated Use {.wrap} instead
      def decorate(...)
        warn("Response.decorate is deprecated and will be removed in v5.0. Use Response.wrap instead.", uplevel: 1)
        wrap(...)
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
