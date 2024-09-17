# frozen_string_literal: true

require "http"

module Peddler
  # Requests refresh and access tokens that authorize your application to take actions on behalf of a selling partner.
  #
  # The refresh token allows you to generate access tokens. Access tokens expire one hour after they are issued.
  #
  # @see https://developer-docs.amazon.com/sp-api/docs/connecting-to-the-selling-partner-api
  class Token
    class Error < StandardError
      attr_reader :cause

      def initialize(msg = nil, cause = nil)
        @cause = cause
        super(msg)
      end
    end

    URL = "https://api.amazon.com/auth/o2/token"

    attr_reader :client_id, :client_secret, :options

    class << self
      def request(...)
        new(...).request
      end
    end

    def initialize(client_id: ENV["LWA_CLIENT_ID"], client_secret: ENV["LWA_CLIENT_SECRET"], **options)
      @client_id = client_id
      @client_secret = client_secret
      @options = options
    end

    def request
      response = HTTP.post(URL, form: params)

      unless response.status.success?
        message = response.parse["error_description"]
        raise Error.new(message, response)
      end

      response
    end

    private

    def params
      {
        grant_type: grant_type,
        client_id: client_id,
        client_secret: client_secret,
      }.compact.merge(options)
    end

    def grant_type
      return if options.key?(:grant_type)

      if options.key?(:refresh_token)
        "refresh_token"
      elsif options.key?(:scope)
        "client_credentials"
      elsif options.key?(:code)
        "authorization_code"
      end
    end
  end
end
