module Peddler
  module Errors
    # @api private
    class Error < StandardError
      attr_reader :cause

      def initialize(msg, cause)
        @cause = cause
        super msg
      end
    end
  end
end
