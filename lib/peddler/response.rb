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
      # Builds the response of an API call or a signed-URL transfer, raising if it is an HTTP error
      #
      # @!visibility private
      # @raise [Peddler::Error]
      def from_parts(parts, operation = nil)
        status, headers, body, metadata = parts
        new(status, headers, body, metadata, operation: operation).raise_for_status!
      end
    end

    def initialize(status, headers, body, metadata = nil, operation: nil)
      @status = status
      @headers = headers
      @body = body
      @metadata = metadata
      @operation = operation
    end

    # The metadata only supplies Amazon's code, request ID and message. Without it they are nil.
    #
    # @return [self]
    # @raise [Peddler::Error] if the status is outside 2xx
    def raise_for_status!
      return self if (200..299).cover?(status)

      code, request_id, message = @metadata
      raise Error.new(message || "request failed with status #{status}", self, code: code, request_id: request_id)
    end

    # @return [Hash]
    def to_h
      return @to_h if defined?(@to_h)

      @to_h = JSON.parse(body)
    end

    # Extracts a nested value from the parsed body
    def dig(*keys)
      to_h.dig(*keys)
    end

    # Parses the body into the typed model of the operation
    #
    # @return [Object] the typed model, or the Hash when the operation has none or the response is an error
    def parse
      model = parser if (200..299).cover?(status)
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
