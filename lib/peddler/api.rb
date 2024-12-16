# frozen_string_literal: true

require "http"

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

    class << self
      # @return [#call]
      attr_accessor :parser
    end

    # @return [Peddler::Endpoint]
    attr_reader :endpoint

    # @return [String]
    attr_reader :access_token

    # @param [String] aws_region
    # @param [String] access_token
    def initialize(aws_region, access_token)
      @endpoint = Endpoint.find(aws_region)
      @access_token = access_token
      @sandbox = false
    end

    # @return [URI::HTTPS]
    def endpoint_uri
      sandbox? ? endpoint.sandbox : endpoint.production
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
    # @param [Integer] tries
    # @return [self]
    def meter(requests_per_second, tries: 2)
      # HTTP v6.0 will implement retriable. Until then, point to their GitHub repo, or it's a no-op.
      # https://github.com/httprb/http/pull/790
      delay = sandbox? ? 0.2 : 1.0 / requests_per_second
      retriable(delay:, tries:, retry_statuses: [429])

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
        @http = http.send(method, *args, **kwargs, &block) if http.respond_to?(method)
        self
      end
    end
    alias_method :through, :via

    [:get, :post, :put, :delete, :patch].each do |method|
      define_method(method) do |path, **options|
        if options[:body] && !options[:body].is_a?(String)
          options[:json] = options.delete(:body)
        end

        uri = endpoint_uri.tap do |uri|
          uri.path = path
        end

        response = http.send(method, uri, **options)

        if response.status.client_error?
          error = Error.build(response)
          raise error if error
        end

        Response.decorate(response, parser:)
      end
    end

    attr_writer :parser

    # @!attribute parser
    # @return [#call]
    def parser
      @parser || self.class.parser
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
  end
end
