# frozen_string_literal: true

require "http"
require "uri"

require "peddler/config"
require "peddler/endpoint"
require "peddler/error"
require "peddler/marketplace"
require "peddler/response"
require "peddler/version"

module Peddler
  # Wraps an Amazon Selling Partner API (SP-API)
  class API
    class CannotSandbox < StandardError; end
    class MustSandbox < StandardError; end

    # @return [Peddler::Endpoint]
    attr_reader :endpoint

    # @return [String]
    attr_reader :access_token

    # Number of retries if throttled (default: 0)
    #
    # @return [Integer]
    attr_reader :retries

    # @param [String] aws_region The AWS region to use for the endpoint
    # @param [String] access_token The access token for authentication
    # @param [Integer] retries The number of retries if throttled (default: 0)
    def initialize(aws_region, access_token, retries: 0)
      @endpoint = Endpoint.find(aws_region)
      @access_token = access_token
      @retries = retries
      @sandbox = false
    end

    # @return [URI::HTTPS]
    def endpoint_uri
      sandbox? ? endpoint.sandbox : endpoint.production
    end

    # Enables typed response parsing
    # @return [self]
    def typed
      load_types
      @typed = true

      self
    end

    # @return [Boolean]
    def typed?
      !!@typed
    end

    # Switches to the SP-API sandbox to make test calls
    #
    # @see https://developer-docs.amazon.com/sp-api/docs/the-selling-partner-api-sandbox
    # @return [self]
    def sandbox
      @sandbox = true
      self
    end

    # @return [Boolean]
    def sandbox?
      @sandbox
    end

    # @see https://developer-docs.amazon.com/sp-api/docs/include-a-user-agent-header-in-all-requests
    # @see https://developer-docs.amazon.com/amazon-shipping/docs/connecting-to-the-selling-partner-api#step-3-add-headers-to-the-uri
    # @return [HTTP::Client]
    def http
      @http ||= HTTP.headers(
        "Host" => endpoint_uri.host,
        "User-Agent" => user_agent,
        "X-Amz-Access-Token" => access_token,
        "X-Amz-Date" => timestamp,
      )
    end

    # Throttles with a rate limit and retries when the API returns a 429
    #
    # @param [Float] requests_per_second
    # @return [self]
    def meter(requests_per_second)
      return self if retries.zero?

      delay = sandbox? ? 0.2 : 1.0 / requests_per_second
      retriable(delay:, tries: retries + 1, retry_statuses: [429])

      self
    end

    # @!method use(*features)
    #   Turn on [HTTP](https://github.com/httprb/http) features
    #
    #   @param features
    #   @return [self]
    #
    # @!method via(*proxy)
    #   Make a request through an HTTP proxy
    #
    #   @param [Array] proxy
    #   @raise [HTTP::Request::Error] if HTTP proxy is invalid
    #   @return [self]
    #
    # @!method retriable(**options)
    #   Retries requests if they fail due to socket or `5xx` errors
    #
    #   @param (see Performer#initialize)
    #   @return [self]
    [:via, :use, :retriable].each do |method|
      define_method(method) do |*args, **kwargs, &block|
        @http = http.send(method, *args, **kwargs, &block) # steep:ignore
        self
      end
    end
    alias_method :through, :via

    [:get, :post, :put, :delete, :patch].each do |method|
      define_method(method) do |path, parser: nil, **options|
        if options[:body] && !options[:body].is_a?(String)
          options[:json] = options.delete(:body)
        end

        uri = endpoint_uri.tap do |uri| # steep:ignore
          uri.path = path
        end

        http_response = http.send(method, uri, **options) # steep:ignore

        Response.wrap(http_response, parser:)
      end
    end

    private

    def cannot_sandbox!
      raise CannotSandbox, "cannot run in a sandbox" if sandbox?
    end

    def must_sandbox!
      raise MustSandbox, "must run in a sandbox" unless sandbox?
    end

    def user_agent
      "Peddler/#{Peddler::VERSION} (Language=Ruby; #{Socket.gethostname})"
    end

    def timestamp
      Time.now.utc.strftime("%Y%m%dT%H%M%SZ")
    end

    def load_types
      raise NotImplementedError, "subclasses must implement #load_types"
    end

    # Encodes URL path components
    def percent_encode(component)
      URI.encode_uri_component(component)
    end

    # Converts an array to a comma-separated string, or returns the value as-is if not an array
    def stringify_array(val)
      val.is_a?(Array) ? val.join(",") : val
    end
  end
end
