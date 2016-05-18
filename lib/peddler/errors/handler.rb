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
        errors[error['Code']] ||= begin
          klass = Errors.const_set error['Code'], Class.new(Error)
          klass.send(:define_method, :cause) { exception }
          klass.new(error['Message'])
        end
      end
    end
  end
end
