# frozen_string_literal: true

require "json"
require "socket"
require_relative "loader"
Peddler::Native::Loader.require_extension

module Peddler
  # Internals of the native layer. The public classes live at the root.
  module Native
    private_constant :Engine, :DocumentHandle, :UploadHandle, :LwaEngine

    class << self
      def engine(config)
        Engine.from_config(config)
      end

      def lwa_engine(client_id, client_secret, timeout, endpoint)
        LwaEngine.new(client_id, client_secret, timeout, endpoint)
      end

      # Identifies the gem to the Selling Partner API. LWA and signed URLs get the same without the host name.
      #
      # @see https://developer-docs.amazon.com/sp-api/docs/include-a-user-agent-header-in-all-requests
      def user_agent
        "Peddler/#{VERSION} (Language=Ruby; #{Socket.gethostname.gsub(/[^\x20-\x7E]/, "")})"
      end
    end
  end

  class AuthenticationError
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
end

require_relative "sourced_engine"
require_relative "pagination"
require_relative "apis"
require_relative "documents"
require_relative "workflows"
