# frozen_string_literal: true

module Peddler
  module Native
    # Raised after the last good page when a following page can't be requested.
    # Messages never include tokens, bodies or arguments.
    class PaginationError < StandardError
      attr_reader :reason

      def initialize(reason)
        @reason = reason
        super("#{reason.to_s.tr("_", " ")} in pagination response")
      end
    end

    # How arguments change after the first page. By default every argument
    # carries over and only the token is replaced.
    class Continuation
      attr_reader :operation, :keep, :drop, :set

      def initialize(operation: nil, keep: nil, drop: [], set: {})
        @operation = operation
        @keep = keep&.map(&:to_s)&.freeze
        @drop = drop.map(&:to_s).freeze
        @set = set.transform_keys(&:to_s).freeze
        freeze
      end
    end

    # Names the operation, the argument that carries the token and the
    # response field that returns the next one. Nothing is inferred at runtime.
    class Pagination
      NONE = Object.new.freeze
      private_constant :NONE

      attr_reader :operation, :input, :output, :continuation

      def initialize(operation:, input:, output:, continuation: Continuation.new)
        @operation = operation
        @input = input
        @output = output
        @continuation = continuation
        @input_keys = segments(input)
        @output_keys = segments(output)
        freeze
      end

      # Lazily yields one Response per page, requesting the next page only once
      # the consumer asks for it. A page that is an HTTP error ends the
      # enumeration. Arguments are never mutated.
      def pages(engine, arguments, max_pages: nil)
        unless max_pages.nil? || (max_pages.is_a?(Integer) && max_pages >= 0)
          raise ArgumentError, "max_pages must be nil or a non-negative integer"
        end

        initial = normalize(arguments)
        initial_token = token_in(initial)
        generate(initial)
        generate(follow(initial, "probe"))

        Enumerator.new do |yielder|
          # @type var seen: Array[String]
          seen = initial_token ? [initial_token] : []
          fetched = 0
          # @type var token: String?
          token = nil
          until max_pages && fetched >= max_pages
            operation = (token && @continuation.operation) || @operation
            page = token.nil? ? initial : follow(initial, token)
            response = Response.from_parts(engine.operation(operation, generate(page)))
            fetched += 1
            following = failure = nil
            following, failure = next_token(response.body, seen) if response.status.between?(200, 299) && fetched != max_pages
            yielder << response
            raise PaginationError, failure if failure
            break unless following

            token = following
          end
        end
      end

      private

      def segments(pointer)
        raise ArgumentError, "pointer must start with /" unless pointer.is_a?(String) && pointer.start_with?("/")

        pointer.delete_prefix("/").split("/", -1).map { |part| part.gsub("~1", "/").gsub("~0", "~") }
      end

      def normalize(arguments)
        raise ArgumentError, "arguments must be a hash" unless arguments.is_a?(Hash)

        normalized = arguments.transform_keys(&:to_s)
        raise ArgumentError, "duplicate argument names" unless normalized.size == arguments.size

        normalized
      end

      def generate(arguments)
        json = begin
          JSON.generate(arguments)
        rescue JSON::GeneratorError
          nil
        end
        raise ArgumentError, "invalid arguments" unless json

        json
      end

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

      # Returns [token, failure]. Parsing happens outside any rescue so no
      # parser error, which can quote the body, becomes a cause.
      def next_token(body, seen)
        parsed = begin
          JSON.parse(body)
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
          elsif seen.include?(node)
            [nil, :repeated_token]
          else
            seen << node
            [node, nil]
          end
        else [nil, :invalid_token]
        end
      end
    end
  end
end
