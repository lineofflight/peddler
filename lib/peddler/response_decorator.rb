# frozen_string_literal: true

require "delegate"
require "forwardable"

module Peddler
  # Wraps HTTP::Response to allow custom parsing
  class ResponseDecorator < SimpleDelegator
    extend Forwardable

    # @!method dig(*key)
    #   Delegates to the Hash returned by {Response#to_h} to extract a nested
    #   value specified by the sequence of keys
    #
    #   @param [String] key one or more keys
    #   @see https://ruby-doc.org/core/Hash.html#method-i-dig
    def_delegator :to_h, :dig

    class << self
      # Decorates an HTTP::Response
      #
      # @param [HTTP::Response] response
      # @param [nil, #call] parser (if any)
      # @return [ResponseDecorator]
      def decorate(response, parser: nil)
        new(response).tap do |decorator|
          decorator.parser = parser
        end
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
