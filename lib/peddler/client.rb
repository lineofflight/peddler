# frozen_string_literal: true

require "json"

module Peddler
  # The Selling Partner API client
  #
  # The client sends the access token it is given. It never requests, refreshes or caches one: get tokens from
  # Peddler::LWA and keep them where your application can share them.
  #
  # Example:
  #
  #     client = Peddler::Client.new(region: "eu-west-1", access_token: token)
  #     client.orders_v0.get_orders(Peddler::Marketplace.ids("UK"))
  #
  # Example of a token source, asked before every attempt of a call:
  #
  #     client = Peddler::Client.new(region: "eu-west-1", access_token: -> {
  #       Rails.cache.fetch(key, expires_in: 55.minutes) { lwa.refresh(refresh_token: token).access_token }
  #     })
  class Client
    # @rbs @engine: Native::Engine
    # @rbs @endpoint: Endpoint?
    # @rbs @sandbox: bool
    # @rbs @sandbox_view: Client?

    # Every client in a process shares one connection pool, so building one per job is cheap.
    #
    # The token may be a String or a source: anything that responds to `call` and returns the token. A source is
    # called before each attempt of a request that sends the token: every operation, every page of a `*_pages`
    # enumerator, every poll of a `wait_for_*`, the lookup of a document helper, and every retry of those. So a
    # retry minutes later sends a fresh token. It is called from whichever thread makes the call, so it must be
    # thread-safe.
    #
    # Asking the source is part of the attempt, and the time it takes counts against `timeout:`. Ruby can't
    # interrupt a source: one that takes longer than the timeout is waited for, and the attempt has then timed out.
    #
    # @rbs access_token: String | Native::_TokenSource -- a Login with Amazon access token or a restricted data token,
    #   or its source
    # @rbs region: String? -- the AWS region of the selling region, unless base_url is given
    # @rbs base_url: String? -- a custom destination instead of Amazon's endpoint for a region
    # @rbs timeout: Integer | Float -- seconds for each attempt of a call. The waits between retries are not counted.
    # @rbs retries: Integer -- how often to retry a throttled request, or a GET that failed, from 0 to 10
    # @rbs return: void
    # Raises ArgumentError if an option breaks its rule. The message names the option and the rule.
    def initialize(access_token:, region: nil, base_url: nil, timeout: 30, retries: 0)
      raise ArgumentError, "provide either region or base_url" unless region.nil? ^ base_url.nil?
      unless retries.is_a?(Integer) && retries.between?(0, 10)
        raise ArgumentError, "retries must be an Integer between 0 and 10"
      end

      @sandbox = false
      unless region.nil?
        regions = Endpoint::REGIONS.keys
        raise ArgumentError, "region must be one of #{regions.join(", ")}" unless regions.include?(region)

        @endpoint = endpoint = Endpoint.find(region)
        base_url = endpoint.production.to_s
      end
      source = Native.token_source(access_token)
      # The native layer checks the base URL and names it in what it raises.
      config = { base_url: base_url.to_s, access_token: source ? nil : Native.access_token(access_token),
        timeout: Native.timeout(timeout), retries: retries, user_agent: Native.user_agent }
      engine = Native.engine(Native.generate(config) || raise(ArgumentError, "base_url must be valid UTF-8"))
      @engine = source ? engine.with_token_source(source) : engine
    end

    # A view of this client that sends another access token
    #
    # Use it for another seller, a rotated token, or a restricted data token for a few calls.
    #
    # Example:
    #
    #     rdt = client.tokens.create_restricted_data_token({ restrictedResources: resources }).parse
    #     client.with_access_token(rdt.restricted_data_token).orders_v0.get_order_address(id)
    #
    # @rbs access_token: String | Native::_TokenSource -- a token or its source, as in Client.new
    # @rbs return: Client
    def with_access_token(access_token)
      source = Native.token_source(access_token)
      view(source ? @engine.with_token_source(source) : @engine.with_access_token(Native.access_token(access_token)))
    end

    # A view of this client that calls Amazon's sandbox for its region
    #
    # https://developer-docs.amazon.com/sp-api/docs/the-selling-partner-api-sandbox
    #: () -> Client
    def sandbox
      return self if @sandbox

      endpoint = @endpoint
      raise ArgumentError, "cannot use sandbox with a custom base_url" unless endpoint

      @sandbox_view ||= view(@engine.with_base_url(endpoint.sandbox.to_s), sandbox: true)
    end

    #: () -> bool
    def sandbox?
      @sandbox
    end

    # Calls an endpoint Peddler has no method for yet
    #
    # The request carries the client's access token and keeps its timeout and retries, as an operation's method
    # does. Amazon documents no rate for it, so a retry after a 429 waits as one after a 503 does. The response has
    # no typed model, so Peddler::Response#parse returns the Hash.
    #
    # Example:
    #
    #     client.request("GET", "/orders/v0/orders", params: { MarketplaceIds: "ATVPDKIKX0DER" }).to_h
    #
    # @rbs method: String -- the HTTP method, such as "GET", in any case
    # @rbs path: String -- the absolute path, percent-encoded, without a query
    # @rbs params: Hash[String | Symbol, untyped] -- the query. A value is sent as an operation's argument is: a
    #   Peddler::Marketplace as its ID, an Array joined with commas.
    # @rbs body: String | Hash[untyped, untyped] | Array[untyped] | nil -- sent as JSON. A String holds the JSON
    #   already.
    # @rbs return: Response
    # Raises ArgumentError if an argument breaks its rule. The message names the argument.
    # Raises Peddler::Error if the response is outside 2xx.
    # Raises Peddler::TimeoutError if the last attempt takes longer than the client's timeout.
    # Raises Peddler::TransportError if the request can't be sent or the response can't be read.
    # Raises Peddler::ForkError if the client was built before the process forked.
    def request(method, path, params: {}, body: nil)
      raise ArgumentError, "method must be a String" unless method.is_a?(String)
      raise ArgumentError, "path must be a String" unless path.is_a?(String)
      raise ArgumentError, "method must be an HTTP method" unless Native.valid_utf8_string?(method)
      raise ArgumentError, "path must be valid UTF-8" unless Native.valid_utf8_string?(path)
      raise ArgumentError, "params must be a hash" unless params.is_a?(Hash)

      # @type var query: Hash[String, String]
      query = {}
      params.each do |key, value|
        raise ArgumentError, "parameter names must be strings or symbols" unless key.is_a?(String) || key.is_a?(Symbol)

        name = key.to_s
        raise ArgumentError, "parameter names must be valid UTF-8" unless Native.valid_utf8_string?(name)
        raise ArgumentError, "duplicate parameter name" if query.key?(name)

        query[name] = Native::Arguments.parameter(name, value)
      end
      payload = case body
      when nil, String then body
      when Hash, Array then Native.generate(body) || raise(ArgumentError, "body #{Native::Arguments::JSON_RULE}")
      else raise ArgumentError, "body must be a string, hash, array or nil"
      end

      Response.from_parts(@engine.request(method.upcase, path, query.to_a, payload))
    end

    private

    #: (Native::Engine engine, ?sandbox: bool) -> Client
    def view(engine, sandbox: @sandbox)
      view = self.class.allocate
      view.instance_variable_set(:@engine, engine)
      view.instance_variable_set(:@endpoint, @endpoint)
      view.instance_variable_set(:@sandbox, sandbox)
      view
    end
  end
end
