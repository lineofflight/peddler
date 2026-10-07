# frozen_string_literal: true

module Peddler
  # The errors of the native layer. They load before the extension, which only looks them up. Peddler::Error, for
  # HTTP error responses, lives in peddler/error.rb.

  # A request that got no response: it couldn't be sent, or the response couldn't be read
  #
  # The message never holds a URL, a token or an argument.
  class TransportError < StandardError; end

  # A request that took longer than the timeout of the client, or of {Peddler::LWA}
  #
  # The request that looks a document up by its ID, or creates a feed document, raises this too.
  class TimeoutError < TransportError; end

  # A client, a {Peddler::LWA} or a token source that was created before the process forked and is used in the
  # child
  #
  # Create them again in the child. The message names which.
  class ForkError < StandardError; end

  # A token that Login with Amazon didn't grant, or a token source that failed
  #
  # @example
  #   begin
  #     lwa.refresh(refresh_token: seller.refresh_token)
  #   rescue Peddler::AuthenticationError => error
  #     seller.disconnect! if error.code == "invalid_grant"
  #   end
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

    # Supports pattern matching on status and code
    #
    # @example
    #   case error
    #   in code: "invalid_grant" then reauthorize
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

  # A document that couldn't be transferred or read: a broken transfer, invalid compression or content, a limit
  # the document is larger than, or a {Peddler::Document} that is closed or already read
  #
  # A signed URL that answers outside 2xx raises {Peddler::Error}, not this.
  class DocumentError < StandardError; end

  # A download or an upload that ran past its `timeout:`
  class DocumentTimeoutError < DocumentError; end

  # A wait or a document helper that got an answer it can't use: a processing status Peddler doesn't know, or
  # the metadata of a document without a usable URL
  class WorkflowError < StandardError; end

  # A `wait_for_report`, `wait_for_feed` or `wait_for_query` that ran past its own `timeout:`
  #
  # Nothing else raises it. A poll that takes longer than the client's timeout raises {Peddler::TimeoutError}.
  class WorkflowTimeoutError < WorkflowError; end

  # Raised after the last good page when a following page can't be requested.
  # Messages never include tokens, bodies or arguments.
  class PaginationError < StandardError
    # @return [Symbol] what was wrong with the token of the page
    attr_reader :reason

    def initialize(reason)
      @reason = reason
      super("#{reason.to_s.tr("_", " ")} in pagination response")
    end
  end
end
