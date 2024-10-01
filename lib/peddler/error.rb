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
        class_name = error.dig("code")
        klass = const_get(class_name)

        klass.new(error.dig("message"), response)
      rescue NameError
        const_set(class_name, Class.new(Error))
        retry
      end
    end

    def initialize(msg = nil, cause = nil)
      @cause = cause
      super(msg)
    end
  end
end
