# frozen_string_literal: true

require 'forwardable'

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
      extend Forwardable

      attr_reader :cause

      def initialize(msg = nil, cause = nil)
        @cause = cause
        super msg
      end

      def_delegator :cause, :response
    end

    CODES.each do |name|
      const_set name, Class.new(Error)
    end
  end
end
