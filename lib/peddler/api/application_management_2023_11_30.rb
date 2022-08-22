# frozen_string_literal: true

require "peddler/api"

module Peddler
  class API
    # Selling Partner API for Application Management
    #
    # The Selling Partner API for Application Management lets you programmatically update the client secret on
    # registered applications.
    class ApplicationManagement20231130 < API
      # Rotates application client secrets for a developer application. Developers must register a destination queue in
      # the developer console before calling this operation. When this operation is called a new client secret is
      # generated and sent to the developer-registered queue. For more information, refer to [Rotate your application
      # client
      # secret](https://developer-docs.amazon.com/sp-api/v0/docs/application-management-api-v2023-11-30-use-case-guide#tutorial-rotate-your-applications-client-secret).
      # @return [Hash] The API response
      def rotate_application_client_secret
        path = "/applications/2023-11-30/clientSecret"

        retriable(delay: proc { |i| 0.0167 * i }).post(path)
      end
    end
  end
end
