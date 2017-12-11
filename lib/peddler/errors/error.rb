# frozen_string_literal: true

module Peddler
  # @api private
  module Errors
    # Here I curate error classes I see value in creating up front so we can use
    # them for control flow. All other errors will be created at runtime.
    CODES = %w[
      AccessDenied
      InternalError
      InvalidAccessKeyId
      InvalidMarketplace
      QuotaExceeded
      RequestThrottled
    ].freeze

    # @api private
    class Error < StandardError
      attr_reader :cause

      def initialize(msg = nil, cause = nil)
        @cause = cause
        super msg
      end
    end

    CODES.each do |name|
      const_set name, Class.new(Error)
    end
  end
end
