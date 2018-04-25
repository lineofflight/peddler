# frozen_string_literal: true

require 'excon'
require 'peddler/errors/builder'

module Peddler
  module Errors
    # @api private
    class Handler
      DIGIT_AS_FIRST_CHAR = /^\d/
      private_constant :DIGIT_AS_FIRST_CHAR

      def self.call(exception)
        new(exception).handle
      end

      attr_reader :exception

      def initialize(exception)
        @exception = exception
      end

      def handle
        raise exception unless http_status_error?
        raise exception if bad_name_for_error_class?

        raise error_class.new(error_message, exception)
      end

      private

      def error_class
        Errors.const_get(error_name)
      rescue NameError
        Builder.build(error_name)
      end

      def http_status_error?
        exception.is_a?(::Excon::Error::HTTPStatus)
      end

      def bad_name_for_error_class?
        error_name =~ DIGIT_AS_FIRST_CHAR
      end

      def error_name
        exception.response.code
      end

      def error_message
        exception.response.message
      end
    end
  end
end
