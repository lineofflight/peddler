# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module Tokens20210301
      # The response schema for the createRestrictedDataToken operation.
      CreateRestrictedDataTokenResponse = Structure.new do
        # @return [String] A Restricted Data Token (RDT). This is a short-lived access token that authorizes calls to
        # restricted operations. Pass this value with the x-amz-access-token header when making subsequent calls to
        # these restricted resources.
        attribute?(:restricted_data_token, String, from: "restrictedDataToken")

        # @return [Integer] The lifetime of the Restricted Data Token, in seconds.
        attribute?(:expires_in, Integer, from: "expiresIn")
      end
    end
  end
end
