# frozen_string_literal: true

require "http"

require "peddler/error"
require "peddler/region"
require "peddler/version"

module Peddler
  # Wraps an Amazon Selling Partner API (SP-API)
  class API
    class CannotSandbox < StandardError; end
    class MustSandbox < StandardError; end

    # @return [Peddler::Region]
    attr_reader :region

    # @return [String]
    attr_reader :access_token

    # @param [String] aws_region
    # @param [String] access_token
    def initialize(aws_region, access_token)
      @region = Region.new(aws_region)
      @access_token = access_token
      @sandbox = false
    end

    # @return [URI]
    def endpoint
      URI(sandbox? ? region.sandbox_endpoint : region.endpoint)
    end

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

    # @raise [CannotSandbox] if in a sandbox environment
    def cannot_sandbox!
      raise CannotSandbox, "cannot run in a sandbox" if sandbox?
    end

    # @raise [MustSandbox] unless in a sandbox environment
    def must_sandbox!
      raise MustSandbox, "must run in a sandbox" unless sandbox?
    end

    # @see https://developer-docs.amazon.com/sp-api/docs/include-a-user-agent-header-in-all-requests
    # @see https://developer-docs.amazon.com/amazon-shipping/docs/connecting-to-the-selling-partner-api#step-3-add-headers-to-the-uri
    # @return [HTTP::Client]
    def http
      @http ||= HTTP.headers(
        "Host" => endpoint.host,
        "User-Agent" => user_agent,
        "X-Amz-Access-Token" => access_token,
        "X-Amz-Date" => timestamp,
      )
    end

    # Throttles with a rate limit and retries when the API returns a 429
    #
    # @param [Float] rate_limit The delay in seconds before retrying
    # @return [self]
    def meter(rate_limit)
      # HTTP v6.0 will implement retriable. Until then, point to their GitHub repo, or it's a no-op.
      # https://github.com/httprb/http/pull/790
      delay = sandbox? ? 0.2 : 1.0 / rate_limit
      retriable(delay: delay, retry_statuses: [429]) if @http.respond_to?(:retriable)

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
      define_method(method) do |*args, &block|
        @http = http.send(method, *args, &block)
        self
      end
    end
    alias_method :through, :via

    [:get, :post, :put, :delete, :patch].each do |method|
      define_method(method) do |path, **options|
        if options[:body] && !options[:body].is_a?(String)
          options[:json] = options.delete(:body)
        end

        uri = endpoint.tap do |uri|
          uri.path = path
        end

        response = http.send(method, uri, **options)

        if response.status.client_error?
          error = Error.build(response)
          raise error if error
        end

        response
      end
    end

    private

    def user_agent
      "Peddler/#{Peddler::VERSION} (Language=Ruby; #{Socket.gethostname})"
    end

    def timestamp
      Time.now.utc.strftime("%Y%m%dT%H%M%SZ")
    end
  end
end
