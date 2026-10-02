# frozen_string_literal: true

require "json"

module Peddler
  class Response
    # @return [Integer]
    attr_reader :status

    # @return [Array<Array(String, String)>]
    attr_reader :headers

    # @return [String]
    attr_reader :body

    class << self
      # Builds the response of an API call, raising if it is an HTTP error
      #
      # @!visibility private
      # @raise [Peddler::Error]
      def from_parts(parts, operation = nil)
        status, headers, body, metadata = parts
        new(status, headers, body, metadata, operation: operation).raise_for_status!
      end

      # Builds the reply of a signed-URL transfer, which stays inspectable when it is a rejection
      #
      # @!visibility private
      def from_document_parts(parts)
        status, headers, body, metadata, truncated = parts
        new(status, headers, body, metadata, body_truncated: truncated)
      end
    end

    def initialize(status, headers, body, metadata = nil, operation: nil, body_truncated: false)
      @status = status
      @headers = headers
      @body = body
      @metadata = metadata
      @operation = operation
      @body_truncated = body_truncated
    end

    # @return [self]
    # @raise [Peddler::Error] if the status is outside 2xx
    def raise_for_status!
      return self unless @metadata

      code, request_id, message = @metadata
      raise Error.new(message || "request failed with status #{status}", self, code: code, request_id: request_id)
    end

    # Only document uploads can truncate a bounded reply body.
    def body_truncated?
      @body_truncated == true
    end

    # @return [Hash]
    def json
      return @json if defined?(@json)

      @json = JSON.parse(body)
    end
    alias_method :to_h, :json

    # Extracts a nested value from the parsed body
    def dig(*keys)
      to_h.dig(*keys)
    end

    # Parses the body into the typed model of the operation
    #
    # @return [Object] the typed model, or the Hash when the operation has none or the response is an error
    def parse
      model = parser unless @metadata
      model ? model.parse(to_h) : to_h
    end

    private

    def parser
      operation = @operation or return
      parsers = APIs::PARSERS[operation[/\A[^.]+/]] or return

      parsers.call[operation]&.call
    end
  end
end
