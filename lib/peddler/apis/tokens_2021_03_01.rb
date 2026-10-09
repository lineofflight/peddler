# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # Selling Partner API for Tokens
    #
    # The Selling Partner API for Tokens provides a secure way to access a customer's PII (Personally Identifiable
    # Information). You can call the Tokens API to get a Restricted Data Token (RDT) for one or more restricted
    # resources that you specify. The RDT authorizes subsequent calls to restricted operations that correspond to the
    # restricted resources that you specified.
    #
    # For more information, see the {https://developer-docs.amazon.com/sp-api/docs/tokens-api-use-case-guide Tokens API
    # Use Case Guide}.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/tokens-api-model/tokens_2021-03-01.json
    module Tokens20210301
      # Typed models of successful responses, by native operation key. Shareable, so that any Ractor can read it.
      PARSERS = Ractor.make_shareable({
        "tokens_2021_03_01.create_restricted_data_token" => -> { CreateRestrictedDataTokenResponse },
      })
    end
  end
end
