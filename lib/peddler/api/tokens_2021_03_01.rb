# frozen_string_literal: true

require "peddler/api"

module Peddler
  class API
    # Selling Partner API for Tokens
    #
    # The Selling Partner API for Tokens provides a secure way to access a customer's PII (Personally Identifiable
    # Information). You can call the Tokens API to get a Restricted Data Token (RDT) for one or more restricted
    # resources that you specify. The RDT authorizes subsequent calls to restricted operations that correspond to the
    # restricted resources that you specified. For more information, see the [Tokens API Use Case
    # Guide](doc:tokens-api-use-case-guide).
    class Tokens20210301 < API
      # Returns a Restricted Data Token (RDT) for one or more restricted resources that you specify. A restricted
      # resource is the HTTP method and path from a restricted operation that returns Personally Identifiable
      # Information (PII), plus a dataElements value that indicates the type of PII requested. See the Tokens API Use
      # Case Guide for a list of restricted operations. Use the RDT returned here as the access token in subsequent
      # calls to the corresponding restricted operations.
      #
      # @note This operation can make a static sandbox call.
      # @param [Hash] body The restricted data token request details.
      # @param [Float] rate_limit Requests per second
      # @return [Hash] The API response
      def create_restricted_data_token(body, rate_limit: 1.0)
        path = "/tokens/2021-03-01/restrictedDataToken"

        meter(rate_limit).post(path, body:)
      end
    end
  end
end
