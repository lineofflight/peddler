# frozen_string_literal: true

module Peddler
  class Error < StandardError
    class InvalidInput < Error; end
    class NotFound < Error; end
    class QuotaExceeded < Error; end
    class Unauthorized < Error; end

    attr_reader :cause

    # @!visibility private
    class << self
      def build(response)
        error = JSON.parse(response).dig("errors").first
        code = error.dig("code")
        message = error.dig("message")

        class_name ||= code
        klass = const_defined?(class_name) ? const_get(class_name) : const_set(class_name, Class.new(Error))

        klass.new(message, response)
      rescue NameError
        # Fall back on message if code cannot be converted to a class name
        class_name = message.split.map(&:capitalize).join
        retry
      end
    end

    def initialize(msg = nil, cause = nil)
      @cause = cause
      super(msg)
    end
  end
end
