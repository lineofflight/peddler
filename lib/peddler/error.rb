# frozen_string_literal: true

module Peddler
  class Error < StandardError
    class InvalidInput < Error; end
    class NotFound < Error; end
    class QuotaExceeded < Error; end
    class Unauthorized < Error; end

    attr_reader :response

    # @!visibility private
    class << self
      def build(response)
        error = JSON.parse(response).dig("errors").first
        class_name = error.dig("code")
        message = error.dig("message")
        klass = const_defined?(class_name) ? const_get(class_name) : const_set(class_name, Class.new(Error))

        klass.new(message, response)
      rescue NameError
        # Do nothing if code cannot be converted to a class name
      end
    end

    def initialize(msg = nil, response = nil)
      @response = response
      super(msg)
    end
  end
end
