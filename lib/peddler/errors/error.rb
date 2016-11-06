module Peddler
  # @api private
  module Errors
    KNOWN = %w(
      AccessDenied
      InvalidMarketplace
      InvalidParameterValue
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

    KNOWN.each do |name|
      const_set name, Class.new(Error)
    end
  end
end
