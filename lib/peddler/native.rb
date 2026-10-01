# frozen_string_literal: true

require "json"
require "peddler_native"

module Peddler
  module Native
    class Response
      attr_reader :status, :headers, :body

      def initialize(status, headers, body)
        @status = status
        @headers = headers
        @body = body
      end

      def json
        return @json if defined?(@json)

        @json = JSON.parse(body)
      end
    end
  end

  class Client
    def initialize(base_url:, access_token:, timeout: 30)
      @engine = Native::Engine.new(base_url, access_token, timeout)
    end

    def request(method, path, params: {}, body: nil)
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
      status, headers, response_body = @engine.request(method, path, query.to_a, payload)
      Native::Response.new(status, headers, response_body)
    end
  end
end
