# frozen_string_literal: true

require "delegate"
require "json"

module Peddler
  class Response
    # @rbs @to_h: untyped
    # @rbs @metadata: Native::error_metadata?
    # @rbs @operation: String?

    # A status code that behaves as the Integer it is and answers what v5's status answered
    class Status < SimpleDelegator
      #: () -> Integer
      def code = __getobj__

      # @rbs return: String? -- the standard phrase for the code, such as "Not Found"
      def reason = Native.status_reason(code)

      #: () -> bool
      def informational? = code.between?(100, 199)

      #: () -> bool
      def success? = code.between?(200, 299)

      #: () -> bool
      def redirect? = code.between?(300, 399)

      #: () -> bool
      def client_error? = code.between?(400, 499)

      #: () -> bool
      def server_error? = code.between?(500, 599)
    end

    # The headers as pairs in the order they arrived, their names in lowercase, with v5's lookup by name
    class Headers
      # @rbs @pairs: Array[[String, String]]

      include Enumerable #[[String, String]]

      #: (Array[[String, String]] pairs) -> void
      def initialize(pairs)
        @pairs = pairs
      end

      # @rbs name: String | Symbol -- the name of a header, in any case
      # @rbs return: String | Array[String] | nil -- its value, or every value when the header repeats
      def [](name)
        values = @pairs.filter_map { |key, value| value if key.casecmp?(name.to_s) }
        values.size > 1 ? values : values.first
      end

      # @rbs name: String | Symbol -- the name of a header, in any case
      # @rbs return: bool -- whether the response has the header
      def include?(name)
        @pairs.any? { |key, _| key.casecmp?(name.to_s) }
      end

      # Whether the response has the header, as #include? answers
      #: (String | Symbol name) -> bool
      def key?(name) = include?(name)

      # Yields each name and value
      #: () { ([String, String] pair) -> void } -> self
      #: () -> Enumerator[[String, String], self]
      def each(&block)
        return enum_for(:each) unless block

        @pairs.each(&block)
        self
      end

      #: () -> Hash[String, String | Array[String] | nil]
      def to_h
        @pairs.map(&:first).uniq.to_h { |name| [name, self[name]] }
      end
    end

    attr_reader :status #: Status

    attr_reader :headers #: Headers

    # The bytes as they arrived
    attr_reader :body #: String

    # Builds the response of an API call or a signed-URL transfer, raising Peddler::Error if it is an HTTP error
    #: (Native::response_parts parts, ?String? operation) -> Response
    def self.from_parts(parts, operation = nil) # :nodoc:
      status, headers, body, metadata = parts
      new(status, headers, body, metadata, operation: operation).raise_for_status!
    end

    #: (Integer status, Array[[String, String]] headers, String body, ?Native::error_metadata? metadata, ?operation: String?) -> void
    def initialize(status, headers, body, metadata = nil, operation: nil)
      @status = Status.new(status)
      @headers = Headers.new(headers)
      @body = body
      @metadata = metadata
      @operation = operation
    end

    # The metadata only supplies Amazon's code, request ID and message. Without it they are nil.
    #
    # Raises Peddler::Error if the status is outside 2xx.
    #: () -> self
    def raise_for_status!
      return self if status.success?

      error_code, request_id, message = @metadata
      message = "request failed with status #{code}" if message.nil? || message.strip.empty?
      raise Error.new(message, self, code: error_code, request_id: request_id)
    end

    # @rbs return: Integer -- the status code
    def code = status.code

    # The class and the status. Headers and a body can hold a token, so neither is shown.
    #: () -> String
    def inspect = "#<#{self.class} #{code}>"

    # @rbs return: String? -- the charset parameter of the Content-Type
    def charset
      content_type[/;\s*charset=([^;]+)/i, 1]&.strip&.delete('"')
    end

    # The body as text: in the charset of the Content-Type when Ruby knows that encoding, in UTF-8 when it is JSON
    # without one, and binary otherwise
    #: () -> String
    def to_s
      body.dup.force_encoding(encoding)
    end

    # A response is its text wherever a String is taken, as in `JSON.parse(response)`
    #: () -> String
    def to_str = to_s

    # A frozen response, as one made shareable between Ractors is, parses its body on every call.
    #: () -> untyped
    def to_h
      return @to_h if defined?(@to_h)
      return JSON.parse(body) if frozen?

      @to_h = JSON.parse(body)
    end

    # Extracts a nested value from the parsed body
    #: (*untyped keys) -> untyped
    def dig(*keys)
      to_h.dig(*keys)
    end

    # Parses the body into the typed model of the operation
    #
    # @rbs return: untyped -- the typed model, or the Hash when the operation has none or the response is an error
    def parse
      model = parser if status.success?
      model ? model.parse(to_h) : to_h
    end

    private

    #: () -> String
    def content_type
      Array(headers["Content-Type"]).first.to_s
    end

    #: () -> Encoding
    def encoding
      label = charset
      return Encoding.find(label) || Encoding::BINARY if label

      content_type.split(";").first.to_s.strip.casecmp?("application/json") ? Encoding::UTF_8 : Encoding::BINARY
    rescue ArgumentError
      Encoding::BINARY
    end

    #: () -> untyped
    def parser
      operation = @operation or return
      parsers = APIs::PARSERS[operation[/\A[^.]+/]] or return

      parsers.call[operation]&.call
    rescue Ractor::UnsafeError
      # Ruby 3.3 loads code in the main Ractor only, and this is another that found the model not loaded.
      raise Ractor::UnsafeError, "call Peddler.eager_load! in the main Ractor before another Ractor parses a response"
    end
  end
end
