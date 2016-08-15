require 'excon'
require 'peddler/errors/builder'

module Peddler
  module Errors
    # @api private
    class Handler
      def self.call(exception)
        new(exception).handle
      end

      def self.parameters
        1
      end

      attr_reader :exception

      def initialize(exception)
        @exception = exception
      end

      def handle
        if http_status_error?
          raise error_class.new(exception.response.message, exception)
        else
          raise exception
        end
      rescue NameError
        raise exception
      end

      private

      def error_class
        Errors.const_get(exception.response.code)
      rescue NameError
        Builder.build(exception.response.code)
      end

      def http_status_error?
        exception.is_a?(::Excon::Error::HTTPStatus)
      end
    end
  end
end
