# frozen_string_literal: true

module Peddler
  # An HTTP error response from the Selling Partner API
  #
  # Transport, authentication, pagination, document and workflow failures have their own classes and don't descend
  # from this one.
  class Error < StandardError
    # @rbs @response: Response?
    # @rbs @code: String?
    # @rbs @request_id: String?

    attr_reader :response #: Response?

    # Amazon's error code
    attr_reader :code #: String?

    attr_reader :request_id #: String?

    #: (?String? message, ?Response? response, ?code: String?, ?request_id: String?) -> void
    def initialize(message = nil, response = nil, code: nil, request_id: nil)
      @response = response
      @code = code
      @request_id = request_id
      super(message)
    end

    #: () -> Integer?
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
    #: (Array[Symbol]? keys) -> Hash[Symbol, untyped]
    def deconstruct_keys(keys)
      hash = { status: status, code: code }
      keys ? hash.slice(*keys) : hash
    end
  end
end
