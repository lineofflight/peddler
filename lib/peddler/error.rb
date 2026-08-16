# frozen_string_literal: true

module Peddler
  class Error < StandardError
    # @return [HTTP::Response, nil]
    attr_reader :response

    class << self
      # Builds the error a failed (4xx or 5xx) response represents
      #
      # @!visibility private
      # @param [HTTP::Response] response
      # @return [Error]
      def build(response)
        Builder.new(response).build
      end
    end

    def initialize(msg = nil, response = nil)
      @response = response
      super(msg)
    end

    # @return [Integer, nil]
    def status
      response&.status&.code
    end

    # Supports pattern matching on status
    #
    # @example
    #   case error
    #   in status: 429 then backoff
    #   in status: 500..599 then retry
    #   end
    #
    # @param [Array<Symbol>, nil] keys
    # @return [Hash]
    def deconstruct_keys(keys)
      hash = { status: status }
      keys ? hash.slice(*keys) : hash
    end
  end
end
