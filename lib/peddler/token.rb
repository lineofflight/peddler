# frozen_string_literal: true

require "http"

require "peddler/error"

module Peddler
  # Requests refresh and access tokens that authorize your application to take actions on behalf of a selling partner.
  #
  # The refresh token allows you to generate access tokens. Access tokens expire one hour after they are issued.
  #
  # @see https://developer-docs.amazon.com/sp-api/docs/connecting-to-the-selling-partner-api
  class Token
    Error = Class.new(Peddler::Error)

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

      if response.status.client_error?
        error = Error.build(response)
        raise error if error
      end

      response
    end

    def grant_type
      if options.key?(:grant_type)
        options[:grant_type]
      elsif options.key?(:refresh_token)
        "refresh_token"
      elsif options.key?(:scope)
        "client_credentials"
      elsif options.key?(:code)
        "authorization_code"
      end
    end

    private

    def params
      {
        grant_type: grant_type,
        client_id: client_id,
        client_secret: client_secret,
      }.compact.merge(options)
    end
  end
end
