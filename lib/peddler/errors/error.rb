# frozen_string_literal: true

module Peddler
  # @api private
  module Errors
    # These error codes are common to all Amazon MWS API sections.
    #
    # @see https://docs.developer.amazonservices.com/en_US/dev_guide/DG_Errors.html
    CODES = %w[
      AccessDenied
      InputStreamDisconnected
      InternalError
      InvalidAccessKeyId
      InvalidAddress
      InvalidParameterValue
      QuotaExceeded
      RequestThrottled
      SignatureDoesNotMatch
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
