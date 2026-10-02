# frozen_string_literal: true

module Peddler
  # The errors of the native layer. They load before the extension, which only looks them up. Peddler::Error, for
  # HTTP error responses, lives in peddler/error.rb.

  class TransportError < StandardError; end

  class TimeoutError < TransportError; end

  class ForkError < StandardError; end

  class AuthenticationError < StandardError
    # @return [Integer, nil] the HTTP status when Login with Amazon rejected the request
    attr_reader :status

    # @return [String, nil] what Login with Amazon names as the problem, such as "invalid_client" or "invalid_grant"
    attr_reader :code

    def initialize(message, status = nil, code: nil)
      @status = status
      @code = code
      super(message)
    end
  end

  class DocumentError < StandardError
    # Set when an upload fails after its feed document was created.
    attr_reader :document_id

    def with_document_id(document_id)
      @document_id = document_id
      self
    end
  end

  class DocumentTimeoutError < DocumentError; end

  class WorkflowError < StandardError; end

  class WorkflowTimeoutError < WorkflowError; end

  # Raised after the last good page when a following page can't be requested.
  # Messages never include tokens, bodies or arguments.
  class PaginationError < StandardError
    attr_reader :reason

    def initialize(reason)
      @reason = reason
      super("#{reason.to_s.tr("_", " ")} in pagination response")
    end
  end
end
