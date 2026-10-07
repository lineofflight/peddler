# frozen_string_literal: true

require "delegate"
require "json"

module Peddler
  class Response
    # A status code that behaves as the Integer it is and answers what v5's status answered
    class Status < SimpleDelegator
      # @return [Integer]
      def code = __getobj__

      # @return [String, nil] the standard phrase for the code, such as "Not Found"
      def reason = Native.status_reason(code)

      def informational? = code.between?(100, 199)
      def success? = code.between?(200, 299)
      def redirect? = code.between?(300, 399)
      def client_error? = code.between?(400, 499)
      def server_error? = code.between?(500, 599)
    end

    # The headers as pairs in the order they arrived, their names in lowercase, with v5's lookup by name
    class Headers
      include Enumerable

      def initialize(pairs)
        @pairs = pairs
      end

      # @param [String] name the name of a header, in any case
      # @return [String, Array<String>, nil] its value, or every value when the header repeats
      def [](name)
        values = @pairs.filter_map { |key, value| value if key.casecmp?(name.to_s) }
        values.size > 1 ? values : values.first
      end

      # Yields each name and value
      def each(&block)
        return enum_for(:each) unless block

        @pairs.each(&block)
        self
      end

      # @return [Hash{String => String, Array<String>}]
      def to_h
        @pairs.map(&:first).uniq.to_h { |name| [name, self[name]] }
      end
    end

    # @return [Status]
    attr_reader :status

    # @return [Headers]
    attr_reader :headers

    # @return [String] the bytes as they arrived
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
      @status = Status.new(status)
      @headers = Headers.new(headers)
      @body = body
      @metadata = metadata
      @operation = operation
    end

    # The metadata only supplies Amazon's code, request ID and message. Without it they are nil.
    #
    # @return [self]
    # @raise [Peddler::Error] if the status is outside 2xx
    def raise_for_status!
      return self if status.success?

      error_code, request_id, message = @metadata
      raise Error.new(message || "request failed with status #{code}", self, code: error_code, request_id: request_id)
    end

    # @return [Integer] the status code
    def code = status.code

    # The class and the status. Headers and a body can hold a token, so neither is shown.
    #
    # @return [String]
    def inspect = "#<#{self.class} #{code}>"

    # @return [String, nil] the charset parameter of the Content-Type
    def charset
      content_type[/;\s*charset=([^;]+)/i, 1]&.strip&.delete('"')
    end

    # The body as text: in the charset of the Content-Type when Ruby knows that encoding, in UTF-8 when it is JSON
    # without one, and binary otherwise
    #
    # @return [String]
    def to_s
      body.dup.force_encoding(encoding)
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
      model = parser if status.success?
      model ? model.parse(to_h) : to_h
    end

    private

    def content_type
      Array(headers["Content-Type"]).first.to_s
    end

    def encoding
      label = charset
      return Encoding.find(label) || Encoding::BINARY if label

      content_type.split(";").first.to_s.strip.casecmp?("application/json") ? Encoding::UTF_8 : Encoding::BINARY
    rescue ArgumentError
      Encoding::BINARY
    end

    def parser
      operation = @operation or return
      parsers = APIs::PARSERS[operation[/\A[^.]+/]] or return

      parsers.call[operation]&.call
    end
  end
end
