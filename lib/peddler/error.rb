# frozen_string_literal: true

module Peddler
  # An HTTP error response from the Selling Partner API
  #
  # Transport, authentication, pagination, document and workflow failures have their own classes and don't descend
  # from this one.
  class Error < StandardError
    # @return [Peddler::Response, nil]
    attr_reader :response

    # @return [String, nil] Amazon's error code
    attr_reader :code

    # @return [String, nil]
    attr_reader :request_id

    def initialize(message = nil, response = nil, code: nil, request_id: nil)
      @response = response
      @code = code
      @request_id = request_id
      super(message)
    end

    # @return [Integer, nil]
    def status
      response&.code
    end

    # Supports pattern matching on status and code
    #
    # @example
    #   case error
    #   in status: 429 then backoff
    #   in code: "QuotaExceeded" then backoff
    #   in status: 500.. then retry_later
    #   end
    #
    # @param [Array<Symbol>, nil] keys
    # @return [Hash]
    def deconstruct_keys(keys)
      hash = { status: status, code: code }
      keys ? hash.slice(*keys) : hash
    end
  end
end
