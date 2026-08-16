# frozen_string_literal: true

require "http"
require "uri"

module Peddler
  # Wraps an Amazon Selling Partner API (SP-API)
  class API
    class CannotSandbox < StandardError; end
    class MustSandbox < StandardError; end

    TRANSIENT_STATUSES = [429, 500, 502, 503, 504].freeze

    # @return [Peddler::Endpoint]
    attr_reader :endpoint

    # @return [String]
    attr_reader :access_token

    # Number of retries if throttled (default: 0)
    #
    # @return [Integer]
    attr_reader :retries

    # @return [URI::HTTP, nil] Custom backend the client points at, if overridden.
    #   Only the scheme, host, and port are used; any path is ignored.
    attr_reader :base_url

    # @param [String] aws_region The AWS region to use for the endpoint
    # @param [String] access_token The access token for authentication
    # @param [Integer] retries The number of retries if throttled (default: 0)
    # @param [HTTP::Client] http HTTP client
    # @param [String, nil] base_url Custom base URL to override the Amazon endpoint
    def initialize(aws_region, access_token, retries: 0, http: HTTP::Client.new, base_url: nil)
      @endpoint = Endpoint.find(aws_region)
      @access_token = access_token
      @retries = retries
      @http = http
      @sandbox = false
      @base_url = parse_base_url(base_url)
    end

    # @return [URI::HTTP]
    def endpoint_uri
      return base_url.dup if base_url

      sandbox? ? endpoint.sandbox : endpoint.production
    end

    # Switches to the SP-API sandbox to make test calls
    #
    # @see https://developer-docs.amazon.com/sp-api/docs/the-selling-partner-api-sandbox
    # @return [self]
    def sandbox
      raise CannotSandbox, "cannot use sandbox with a custom base_url" if base_url

      @sandbox = true
      self
    end

    # @return [Boolean]
    def sandbox?
      @sandbox
    end

    # @see https://developer-docs.amazon.com/sp-api/docs/include-a-user-agent-header-in-all-requests
    # @see https://developer-docs.amazon.com/amazon-shipping/docs/connecting-to-the-selling-partner-api#step-3-add-headers-to-the-uri
    # @return [HTTP::Session]
    def http(rate_limit: nil)
      # @type var client: untyped
      client = @http.headers(
        "Host" => host_header,
        "User-Agent" => user_agent,
        "X-Amz-Access-Token" => access_token,
        "X-Amz-Date" => timestamp,
      )

      return client if retries.zero?

      on_retry = ->(_req, _err, res) {
        Thread.current[:peddler_last_retry_status] = res&.status
      }

      delay = ->(iteration) {
        last_status = Thread.current[:peddler_last_retry_status]

        if last_status == 429 && rate_limit
          # Rate-limit-aware exponential backoff with jitter if throttled
          # @see https://aws.amazon.com/blogs/architecture/exponential-backoff-and-jitter/
          initial_delay = sandbox? ? 0.2 : 1.0 / rate_limit
          (initial_delay * (2.0**(iteration - 1))) + (rand * 0.1)
        else
          # Standard backoff for network errors and 5xx
          (2.0**(iteration - 1)) - 1 + rand
        end
      }

      client.retriable(
        tries: retries + 1,
        delay: delay,
        on_retry: on_retry,
        retry_statuses: TRANSIENT_STATUSES,
      )
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
    rescue HTTP::OutOfRetriesError => e
      raise e unless e.response

      raise Error.build(e.response)
    end

    def cannot_sandbox!
      return if base_url

      raise CannotSandbox, "cannot run in a sandbox" if sandbox?
    end

    def must_sandbox!
      return if base_url

      raise MustSandbox, "must run in a sandbox" unless sandbox?
    end

    def host_header
      uri = endpoint_uri
      host = uri.host.to_s
      uri.port == uri.default_port ? host : "#{host}:#{uri.port}"
    end

    def parse_base_url(value)
      return unless value

      uri = URI.parse(value)
      return uri if uri.is_a?(URI::HTTP) && !uri.host.to_s.empty?

      raise ArgumentError, "base_url must be a full http(s) URL, e.g. http://localhost:9001"
    rescue URI::InvalidURIError
      raise ArgumentError, "base_url must be a full http(s) URL, e.g. http://localhost:9001"
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
