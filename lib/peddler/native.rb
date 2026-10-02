# frozen_string_literal: true

require "json"
require "peddler_native"

module Peddler
  module Native
    class AuthenticationError
      attr_reader :status

      def initialize(message, status = nil)
        @status = status
        super(message)
      end
    end

    class APIError < StandardError
      attr_reader :response, :code, :request_id, :kind

      def initialize(response, metadata)
        @response = response
        @kind, @code, @request_id = metadata
        super("API response status #{response.status} (#{kind})")
      end
    end

    class Response
      attr_reader :status, :headers, :body

      class << self
        def from_parts(parts)
          status, headers, body, metadata = parts
          new(status, headers, body, metadata)
        end
      end

      def initialize(status, headers, body, metadata = :unclassified)
        @status = status
        @headers = headers
        @body = body
        @metadata = metadata == :unclassified ? Native.response_metadata(status, headers, body) : metadata
      end

      def raise_for_status!
        metadata = @metadata
        raise APIError.new(self, metadata) if metadata

        self
      end

      def json
        return @json if defined?(@json)

        @json = JSON.parse(body)
      end
    end
  end

  class Client
    DEFAULT_LWA_ENDPOINT = "https://api.amazon.com/auth/o2/token"

    def initialize(base_url:, access_token: nil, client_id: nil, client_secret: nil, refresh_token: nil, scope: nil,
      timeout: 30, retries: 0, retry_delay: 0.2, max_retry_delay: 30, rate_limits: {}, lwa_endpoint: DEFAULT_LWA_ENDPOINT)
      config = { base_url: base_url, access_token: access_token, client_id: client_id, client_secret: client_secret,
        refresh_token: refresh_token, scope: scope, timeout: timeout, retries: retries, retry_delay: retry_delay,
        max_retry_delay: max_retry_delay, rate_limits: rate_limits, lwa_endpoint: lwa_endpoint }
      @engine = Native::Engine.from_config(JSON.generate(config))
    rescue JSON::GeneratorError
      raise ArgumentError, "invalid configuration"
    end

    def restricted(resources:, target_application: nil)
      engine = @engine.restricted(JSON.generate(resources: resources, target_application: target_application))
      view = self.class.allocate
      view.instance_variable_set(:@engine, engine)
      view
    rescue JSON::GeneratorError
      raise ArgumentError, "invalid restricted scope"
    end

    def request(method, path, params: {}, body: nil, operation: "raw")
      raise TypeError, "method and path must be strings" unless method.is_a?(String) && path.is_a?(String)
      raise ArgumentError, "params must be a hash" unless params.is_a?(Hash)

      # @type var query: Hash[String, String]
      query = {}
      params.each do |key, value|
        raise ArgumentError, "parameter names must be strings or symbols" unless key.is_a?(String) || key.is_a?(Symbol)

        name = key.to_s
        raise ArgumentError, "duplicate parameter name" if query.key?(name)
        unless value.is_a?(String) || value.is_a?(Integer) || value == true || value == false || (value.is_a?(Float) && value.finite?)
          raise ArgumentError, "parameter values must be strings, finite numbers or booleans"
        end

        query[name] = value.to_s
      end
      payload = case body
      when nil, String then body
      when Hash, Array then JSON.generate(body)
      else raise ArgumentError, "body must be a string, hash, array or nil"
      end
      raise TypeError, "operation must be a string" unless operation.is_a?(String)

      Native::Response.from_parts(@engine.request_with_operation(operation, method, path, query.to_a, payload))
    end

    # Lazily enumerates raw pages for an explicit Native::Pagination mapping.
    def pages(pagination, arguments, max_pages: nil)
      pagination.pages(@engine, arguments, max_pages: max_pages)
    end
  end
end

require_relative "native/pagination"
require_relative "native/apis"

require_relative "native/documents"
require_relative "native/lwa"
