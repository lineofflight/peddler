# frozen_string_literal: true

require "delegate"
require "forwardable"

require "peddler/error"

# TODO: Consider integrating HTTP gem's raise_error feature when available in stable release
#
# The HTTP gem's main branch includes a :raise_error feature that automatically raises
# HTTP::StatusError for client/server errors. This would simplify our error handling:
#
# Current approach:
#   - Manually check response.status.client_error? in Response.wrap
#   - Parse error response body to create specific Peddler::Error subclasses
#   - Fall back to raising generic Peddler::Error if parsing fails (e.g., no Nokogiri)
#
# Future approach with HTTP raise_error:
#   - Configure HTTP client globally: HTTP.use(:raise_error)
#   - Rescue HTTP::StatusError and parse response body
#   - Create Peddler::Error that inherits from HTTP::StatusError
#   - Re-raise original HTTP::StatusError if parsing fails
#
# Benefits:
#   - Leverages standard HTTP gem patterns
#   - Maintains compatibility with code that rescues HTTP::StatusError
#   - Reduces boilerplate (inherits response accessor and other functionality)
#
# Blockers:
#   - :raise_error feature is only available in HTTP gem main branch, not stable releases
#   - Would need to wait for next HTTP gem release or force unreleased dependency
#
# When HTTP releases this feature, we should evaluate switching to this approach.

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
      # Wraps an HTTP::Response with error handling and parsing capabilities
      #
      # @param [HTTP::Response] response
      # @param [nil, #call] parser (if any)
      # @return [Response]
      # @raise [Peddler::Error] if response has client or server error status
      def wrap(response, parser: nil)
        if response.status.client_error? || response.status.server_error?
          error = Error.build(response)
          error ? raise(error) : raise(Error.new("#{response.status.code} #{response.status.reason}", response))
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
