# frozen_string_literal: true

require "http"
require "uri"

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
    # @param [HTTP::Client] http HTTP client
    def initialize(aws_region, access_token, retries: 0, http: HTTP)
      @endpoint = Endpoint.find(aws_region)
      @access_token = access_token
      @retries = retries
      @http = http
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
    def http(rate_limit: nil)
      client = @http.headers(
        "Host" => endpoint_uri.host,
        "User-Agent" => user_agent,
        "X-Amz-Access-Token" => access_token,
        "X-Amz-Date" => timestamp,
      )

      return client if retries.zero? || rate_limit.nil?

      delay = sandbox? ? 0.2 : 1.0 / rate_limit
      client.retriable(delay:, tries: retries + 1, retry_statuses: [429]) # steep:ignore NoMethod
    end

    private

    def get(path, rate_limit: nil, parser: nil, **options)
      request(:get, path, rate_limit:, parser:, **options)
    end

    def post(path, rate_limit: nil, parser: nil, **options)
      request(:post, path, rate_limit:, parser:, **options)
    end

    def put(path, rate_limit: nil, parser: nil, **options)
      request(:put, path, rate_limit:, parser:, **options)
    end

    def delete(path, rate_limit: nil, parser: nil, **options)
      request(:delete, path, rate_limit:, parser:, **options)
    end

    def patch(path, rate_limit: nil, parser: nil, **options)
      request(:patch, path, rate_limit:, parser:, **options)
    end

    def request(method, path, rate_limit: nil, parser: nil, **options)
      options[:json] = options.delete(:body) if options[:body] && !options[:body].is_a?(String)

      uri = endpoint_uri.tap { |u| u.path = path }
      http_response = http(rate_limit:).send(method, uri, **options)

      Response.wrap(http_response, parser:)
    end

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

    def percent_encode(component)
      URI.encode_uri_component(component)
    end

    def stringify_array(val)
      val.is_a?(Array) ? val.join(",") : val
    end
  end
end
