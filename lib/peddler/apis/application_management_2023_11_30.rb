# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/api"

module Peddler
  class << self
    def application_management_2023_11_30
      APIs::ApplicationManagement20231130
    end
  end

  module APIs
    # Selling Partner API for Application Management
    #
    # The Selling Partner API for Application Management lets you programmatically update the client secret on
    # registered applications.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/application-management-api-model/application_2023-11-30.json
    class ApplicationManagement20231130 < API
      # Rotates application client secrets for a developer application. Developers must register a destination queue in
      # the developer console before calling this operation. When this operation is called a new client secret is
      # generated and sent to the developer-registered queue. For more information, refer to [Rotate your application
      # client
      # secret](https://developer-docs.amazon.com/sp-api/v0/docs/application-management-api-v2023-11-30-use-case-guide#tutorial-rotate-your-applications-client-secret).
      #
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def rotate_application_client_secret(rate_limit: 0.0167)
        cannot_sandbox!

        path = "/applications/2023-11-30/clientSecret"
        meter(rate_limit).post(path)
      end
    end
  end
end
