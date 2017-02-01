module Peddler
  # @api private
  module Errors
    # Known codes
    CODES = %w(
      AccessDenied
      InvalidMarketplace
      InvalidParameterValue
      InvalidRequest
      MalformedInput
      QuotaExceeded
      RequestThrottled
    ).freeze

    # @api private
    class Error < StandardError
      attr_reader :cause

      def initialize(msg, cause)
        @cause = cause
        super msg
      end
    end

    CODES.each do |name|
      const_set name, Class.new(Error)
    end
  end
end
