# frozen_string_literal: true

require "json"

module Peddler
  # The Selling Partner API client
  #
  # @example
  #   client = Peddler::Client.new(region: "eu-west-1", refresh_token: seller.refresh_token)
  #   client.orders_v0.get_orders(marketplace_ids: Peddler::Marketplace.ids("UK"))
  class Client
    DEFAULT_LWA_ENDPOINT = "https://api.amazon.com/auth/o2/token"

    # @param [String] region the AWS region of the selling region, unless base_url is given
    # @param [String] base_url a custom destination instead of Amazon's endpoint for a region
    # @param [Boolean] sandbox whether to call Amazon's sandbox for the region
    # @param [String] refresh_token a seller's refresh token; the client requests and refreshes access tokens
    # @param [String] access_token a static access token, instead of a refresh token
    # @param [String] scope the scope of a grantless operation, instead of a refresh token
    # @param [String] client_id defaults to LWA_CLIENT_ID in the environment
    # @param [String] client_secret defaults to LWA_CLIENT_SECRET in the environment
    def initialize(region: nil, base_url: nil, sandbox: false, refresh_token: nil, access_token: nil, scope: nil,
      client_id: nil, client_secret: nil, timeout: 30, retries: 0, retry_delay: 0.2, max_retry_delay: 30,
      rate_limits: {}, lwa_endpoint: DEFAULT_LWA_ENDPOINT)
      raise ArgumentError, "provide either region or base_url" unless region.nil? ^ base_url.nil?
      raise ArgumentError, "cannot use sandbox with a custom base_url" if base_url && sandbox

      @sandbox = sandbox ? true : false
      if region
        @endpoint = endpoint = Endpoint.find(region)
        base_url = (@sandbox ? endpoint.sandbox : endpoint.production).to_s
      end
      if refresh_token || scope
        client_id ||= ENV["LWA_CLIENT_ID"]
        client_secret ||= ENV["LWA_CLIENT_SECRET"]
      end
      config = { base_url: base_url, access_token: access_token, client_id: client_id, client_secret: client_secret,
        refresh_token: refresh_token, scope: scope, timeout: timeout, retries: retries, retry_delay: retry_delay,
        max_retry_delay: max_retry_delay, rate_limits: rate_limits, lwa_endpoint: lwa_endpoint,
        user_agent: Native.user_agent }
      @engine = Native.engine(JSON.generate(config))
    rescue JSON::GeneratorError
      raise ArgumentError, "invalid configuration"
    end

    # A view of this client that calls Amazon's sandbox for its region
    #
    # @see https://developer-docs.amazon.com/sp-api/docs/the-selling-partner-api-sandbox
    # @return [Peddler::Client]
    def sandbox
      return self if @sandbox

      endpoint = @endpoint
      raise ArgumentError, "cannot use sandbox with a custom base_url" unless endpoint

      view(@engine.with_base_url(endpoint.sandbox.to_s), sandbox: true)
    end

    # @return [Boolean]
    def sandbox?
      @sandbox
    end

    def restricted(resources:, target_application: nil)
      view(@engine.restricted(JSON.generate(resources: resources, target_application: target_application)))
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

      Response.from_parts(@engine.request_with_operation(operation, method, path, query.to_a, payload), operation)
    end

    # Lazily enumerates raw pages for an explicit Pagination mapping.
    def pages(pagination, arguments, max_pages: nil)
      pagination.pages(@engine, arguments, max_pages: max_pages)
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
