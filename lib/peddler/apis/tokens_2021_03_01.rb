
require "peddler/api"


module Peddler
  class << self
    def tokens_2021_03_01(...)
      APIs::Tokens20210301.new(...)
    end
  end

  module APIs
        # Selling Partner API for Tokens
    #
        # The Selling Partner API for Tokens provides a secure way to access a customer's PII (Personally Identifiable
    # Information). You can call the Tokens API to get a Restricted Data Token (RDT) for one or more restricted
    # resources that you specify. The RDT authorizes subsequent calls to restricted operations that correspond to the
    # restricted resources that you specified. For more information, see the
    # {https://developer-docs.amazon.com/sp-api/docs/tokens-api-use-case-guide Tokens API Use Case Guide}.
    class Tokens20210301 < API
      
      
              # Returns a Restricted Data Token (RDT) for one or more restricted resources that you specify. A restricted
      # resource is the HTTP method and path from a restricted operation that returns Personally Identifiable
      # Information (PII), plus a dataElements value that indicates the type of PII requested. See the Tokens API Use
      # Case Guide for a list of restricted operations. Use the RDT returned here as the access token in subsequent
      # calls to the corresponding restricted operations.
#
        # @note This operation can make a static sandbox call.
        # @param body [Hash] The restricted data token request details.
        # @param rate_limit [Float] Requests per second
        # @return [Peddler::Response] The API response
      def create_restricted_data_token(body, rate_limit: 1.0)
path = "/tokens/2021-03-01/restrictedDataToken"

  meter(rate_limit).post(path, body:)

end

      
    end
  end
end
