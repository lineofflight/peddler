# frozen_string_literal: true

module Peddler
  class Error < StandardError
    attr_reader :response

    # @!visibility private
    class << self
      def build(response)
        payload = JSON.parse(response)

        if payload.key?("error")
          class_name = normalize_class_name(payload["error"])
          message = payload["error_description"]
        elsif payload.key?("errors")
          class_name = normalize_class_name(payload.dig("errors", 0, "code"))
          message = payload.dig("errors", 0, "message")
        else
          return
        end

        klass = if Errors.const_defined?(class_name)
          Errors.const_get(class_name)
        else
          Errors.const_set(
            class_name,
            Class.new(Error),
          )
        end

        klass.new(message, response)
      rescue NameError
        # Do nothing if code cannot be converted to a class name
      end

      private

      def normalize_class_name(code)
        if code.match?(/\A([a-z_]+|[A-Z_]+)\z/)
          code.split("_").map(&:capitalize).join
        else
          code
        end
      end
    end

    def initialize(msg = nil, response = nil)
      @response = response
      super(msg)
    end
  end

  module Errors
    class InvalidGrant < Error; end
    class InvalidInput < Error; end
    class NotFound < Error; end
    class QuotaExceeded < Error; end
    class Unauthorized < Error; end
    class UnsupportedGrantType < Error; end
  end
end
