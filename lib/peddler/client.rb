# frozen_string_literal: true

require "json"

module Peddler
  # The Selling Partner API client
  #
  # The client sends the access token it is given. It never requests, refreshes or caches one: get tokens from
  # {Peddler::LWA} and keep them where your application can share them.
  #
  # @example
  #   client = Peddler::Client.new(region: "eu-west-1", access_token: token)
  #   client.orders_v0.get_orders(Peddler::Marketplace.ids("UK"))
  # @example A token source, asked before every request
  #   client = Peddler::Client.new(region: "eu-west-1", access_token: -> {
  #     Rails.cache.fetch(key, expires_in: 55.minutes) { lwa.refresh(refresh_token: token).access_token }
  #   })
  class Client
    # Every client in a process shares one connection pool, so building one per job is cheap.
    #
    # The token may be a String or a source: anything that responds to `call` and returns the token. A source is
    # called before each request the client starts (every operation, every page of a `*_pages` enumerator), from
    # whichever thread makes the call, so it must be thread-safe. `wait_for_*` and the document helpers call it once.
    #
    # @param [String, #call] access_token a Login with Amazon access token or a restricted data token, or its source
    # @param [String] region the AWS region of the selling region, unless base_url is given
    # @param [String] base_url a custom destination instead of Amazon's endpoint for a region
    # @param [Numeric] timeout seconds for a whole call, including retries
    # @param [Integer] retries how often to retry a throttled or failed GET, from 0 to 10
    # @raise [ArgumentError] if an option breaks its rule. The message names the option and the rule.
    def initialize(access_token:, region: nil, base_url: nil, timeout: 30, retries: 0)
      raise ArgumentError, "provide either region or base_url" unless region.nil? ^ base_url.nil?
      unless retries.is_a?(Integer) && retries.between?(0, 10)
        raise ArgumentError, "retries must be an Integer between 0 and 10"
      end

      @sandbox = false
      if region
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
    # @example
    #   rdt = client.tokens.create_restricted_data_token({ restrictedResources: resources }).parse
    #   client.with_access_token(rdt.restricted_data_token).orders_v0.get_order_address(id)
    # @param [String, #call] access_token a token or its source, as in {#initialize}
    # @return [Peddler::Client]
    def with_access_token(access_token)
      source = Native.token_source(access_token)
      view(source ? @engine.with_token_source(source) : @engine.with_access_token(Native.access_token(access_token)))
    end

    # A view of this client that calls Amazon's sandbox for its region
    #
    # @see https://developer-docs.amazon.com/sp-api/docs/the-selling-partner-api-sandbox
    # @return [Peddler::Client]
    def sandbox
      return self if @sandbox

      endpoint = @endpoint
      raise ArgumentError, "cannot use sandbox with a custom base_url" unless endpoint

      @sandbox_view ||= view(@engine.with_base_url(endpoint.sandbox.to_s), sandbox: true)
    end

    # @return [Boolean]
    def sandbox?
      @sandbox
    end

    # Calls an endpoint Peddler has no method for yet
    #
    # The request carries the client's access token and keeps its timeout and retries, as an operation's method
    # does. The response has no typed model, so {Peddler::Response#parse} returns the Hash.
    #
    # @example
    #   client.request("GET", "/orders/v0/orders", params: { MarketplaceIds: "ATVPDKIKX0DER" }).to_h
    # @param [String] method the HTTP method, such as "GET"
    # @param [String] path the absolute path, percent-encoded, without a query
    # @param [Hash{String, Symbol => String, Integer, Float, Boolean}] params the query. A value is sent as its text.
    # @param [Hash, Array, String, nil] body sent as JSON. A String holds the JSON already.
    # @return [Peddler::Response]
    # @raise [Peddler::Error] if the response is outside 2xx
    # @raise [ArgumentError] if an argument breaks its rule. The message names the argument.
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
      when Hash, Array then Native.generate(body) || raise(ArgumentError, "body #{Native::Arguments::JSON_RULE}")
      else raise ArgumentError, "body must be a string, hash, array or nil"
      end

      Response.from_parts(@engine.request(method, path, query.to_a, payload))
    end

    private

    def view(engine, sandbox: @sandbox)
      view = self.class.allocate
      view.instance_variable_set(:@engine, engine)
      view.instance_variable_set(:@endpoint, @endpoint)
      view.instance_variable_set(:@sandbox, sandbox)
      view
    end
  end
end
