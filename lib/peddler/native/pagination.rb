# frozen_string_literal: true

module Peddler
  module Native
    # How arguments change after the first page. By default every argument
    # carries over and only the token is replaced. It is shareable, as a
    # Pagination is, so that any Ractor can read the generated table.
    class Continuation
      # @rbs @operation: String?
      # @rbs @keep: Array[String]?
      # @rbs @drop: Array[String]
      # @rbs @set: Hash[String, untyped]

      attr_reader :operation #: String?
      attr_reader :keep #: Array[String]?
      attr_reader :drop #: Array[String]
      attr_reader :set #: Hash[String, untyped]

      #: (?operation: String?, ?keep: Array[String | Symbol]?, ?drop: Array[String | Symbol], ?set: Hash[String | Symbol, untyped]) -> void
      def initialize(operation: nil, keep: nil, drop: [], set: {})
        @operation = operation
        @keep = keep&.map(&:to_s)
        @drop = drop.map(&:to_s)
        @set = set.transform_keys(&:to_s)
        Ractor.make_shareable(self)
      end
    end

    # Names the operation, the argument that carries the token and the
    # response field that returns the next one. Nothing is inferred at runtime.
    class Pagination
      # @rbs @operation: String
      # @rbs @input: String
      # @rbs @output: String
      # @rbs @continuation: Continuation
      # @rbs @input_keys: Array[String]
      # @rbs @output_keys: Array[String]

      NONE = Object.new.freeze #: Object
      private_constant :NONE

      attr_reader :operation #: String
      attr_reader :input #: String
      attr_reader :output #: String
      attr_reader :continuation #: Continuation

      #: (operation: String, input: String, output: String, ?continuation: Continuation) -> void
      def initialize(operation:, input:, output:, continuation: Continuation.new)
        @operation = operation
        @input = input
        @output = output
        @continuation = continuation
        @input_keys = segments(input)
        @output_keys = segments(output)
        Ractor.make_shareable(self)
      end

      # Lazily yields one Response per page, requesting the next page only once
      # the consumer asks for it. A page that is an HTTP error raises
      # Peddler::Error. Arguments are never mutated. The rate limit is the rate
      # of every page for the wait after a 429.
      #: (Engine engine, Hash[String | Symbol, untyped] arguments, ?Float? rate_limit) -> Enumerator[Response, void]
      def pages(engine, arguments, rate_limit = nil)
        initial = normalize(arguments)
        initial_token = token_in(initial)
        generate(initial)
        # Arguments that have no place for a token fail here, not after the first page.
        generate(follow(initial, "probe"))

        Enumerator.new do |yielder|
          # @type var token: String?
          token = nil
          loop do
            operation = (token && @continuation.operation) || @operation
            page = token.nil? ? initial : follow(initial, token)
            response = Response.from_parts(engine.operation(operation, generate(page), rate_limit), @operation)
            following, failure = next_token(response, token || initial_token)
            yielder << response
            raise PaginationError, failure if failure
            break unless following

            token = following
          end
        end
      end

      private

      #: (String pointer) -> Array[String]
      def segments(pointer)
        raise ArgumentError, "pointer must start with /" unless pointer.is_a?(String) && pointer.start_with?("/")

        pointer.delete_prefix("/").split("/", -1).map { |part| part.gsub("~1", "/").gsub("~0", "~") }
      end

      #: (untyped arguments) -> Hash[String, untyped]
      def normalize(arguments)
        raise ArgumentError, "arguments must be a hash" unless arguments.is_a?(Hash)

        normalized = arguments.transform_keys(&:to_s)
        raise ArgumentError, "duplicate argument names" unless normalized.size == arguments.size

        normalized
      end

      #: (Hash[String, untyped] arguments) -> String
      def generate(arguments)
        Native.generate(arguments) || raise(ArgumentError, "invalid arguments")
      end

      #: (Hash[String, untyped] arguments) -> String?
      def token_in(arguments)
        # @type var node: untyped
        node = arguments
        @input_keys.each do |key|
          return nil unless node.is_a?(Hash)

          node = node[node.key?(key) ? key : node.keys.find { |name| name.to_s == key }]
        end
        return nil if node.nil? || node == ""
        raise ArgumentError, "pagination token argument must be a string" unless node.is_a?(String)

        node
      end

      #: (Hash[String, untyped] initial, String token) -> Hash[String, untyped]
      def follow(initial, token)
        arguments = initial.dup
        first = @input_keys.first
        keep = @continuation.keep
        arguments.select! { |key, _| key == first || keep.include?(key) } if keep
        @continuation.drop.each { |key| arguments.delete(key) unless key == first }
        @continuation.set.each { |key, value| arguments[key] = value }
        assign(arguments, @input_keys, token)
      end

      # Copy on write along the path, so the caller's nested hashes stay intact.
      #: (untyped node, Array[String] keys, untyped value) -> Hash[untyped, untyped]
      def assign(node, keys, value)
        raise ArgumentError, "pagination token argument can't be set" unless node.is_a?(Hash)

        key, *rest = keys
        existing = node.key?(key) ? key : node.keys.find { |name| name.to_s == key }
        child = rest.empty? ? value : assign(existing.nil? ? {} : node[existing], rest, value)
        copy = node.dup
        copy.delete(existing) unless existing.nil?
        copy[key] = child
        copy
      end

      # Returns [token, failure]. A page that returns the token it was requested with would
      # repeat forever. Parsing happens outside any rescue so no parser error, which can quote
      # the body, becomes a cause.
      #: (Response response, String? previous) -> [String?, Symbol?]
      def next_token(response, previous)
        parsed = begin
          response.to_h
        rescue JSON::ParserError, EncodingError
          NONE
        end
        return [nil, :malformed_response] if parsed.equal?(NONE)

        node = parsed
        @output_keys.each do |key|
          return [nil, nil] unless node.is_a?(Hash) && node.key?(key)

          node = node[key]
        end
        case node
        when nil then [nil, nil]
        when String
          if node.empty?
            [nil, nil]
          elsif node == previous
            [nil, :repeated_token]
          else
            # A frozen copy: the String in the parsed body is the caller's to change.
            [-node, nil]
          end
        else [nil, :invalid_token]
        end
      end
    end
  end
end
