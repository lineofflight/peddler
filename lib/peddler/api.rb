# frozen_string_literal: true

require "http"

require "peddler/error"
require "peddler/region"

module Peddler
  # Wraps an Amazon Selling Partner API (SP-API)
  class API
    # @return [Peddler::Region]
    attr_reader :region

    # @return [String]
    attr_reader :access_token

    # @param [String] aws_region
    # @param [String] access_token
    def initialize(aws_region, access_token)
      @region = Region.new(aws_region)
      @access_token = access_token
    end

    def endpoint
      @endpoint ||= region.endpoint
    end

    # @see https://developer-docs.amazon.com/sp-api/docs/the-selling-partner-api-sandbox
    # @return [self]
    def sandbox
      @endpoint = endpoint.sub(/(?:sandbox.)?sellingpartnerapi/, "sandbox.sellingpartnerapi")
      self
    end

    # @see https://developer-docs.amazon.com/sp-api/docs/include-a-user-agent-header-in-all-requests
    # @see https://developer-docs.amazon.com/amazon-shipping/docs/connecting-to-the-selling-partner-api#step-3-add-headers-to-the-uri
    # @return [HTTP::Client]
    def http
      @http ||= HTTP.headers(
        "Host" => endpoint_host,
        "User-Agent" => user_agent,
        "X-Amz-Access-Token" => access_token,
        "X-Amz-Date" => timestamp,
      )
    end

    # Retries with a rate limit when the API returns a 429
    #
    # @param [Float] delay The delay in seconds before retrying
    # @return [self]
    def rate_limit(rate)
      # TODO: Remove guard when HTTP 6.0 is released
      retriable(delay: 1.0 / rate, retry_statuses: [429]) if @http.respond_to?(:retriable)
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
          options[:body] = JSON.dump(options[:body])
        end

        response = http.send(method, [endpoint, path].join, **options)

        if response.status.client_error?
          error = Error.build(response)
          raise error if error
        end

        response
      end
    end

    private

    def endpoint_host
      URI.parse(endpoint).host
    end

    def user_agent
      "Peddler/#{Peddler::VERSION} (Language=Ruby; #{Socket.gethostname})"
    end

    def timestamp
      Time.now.utc.strftime("%Y%m%dT%H%M%SZ")
    end
  end
end
