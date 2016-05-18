require 'peddler/errors/error'

module Peddler
  module Errors
    # @api private
    class Handler
      include Singleton

      def self.call(exception)
        instance.call(exception)
      end

      attr_reader :errors

      def initialize
        @errors = {}
      end

      def call(exception)
        return exception unless exception.is_a?(Excon::Errors::HTTPStatusError)

        error = exception.response.parse
        klass = find_or_create_error_class(error['Code'])

        klass.new(error['Message'], exception)
      end

      private

      def find_or_create_error_class(name)
        errors[name] ||= Errors.const_set name, Class.new(Error)
      end
    end
  end
end
