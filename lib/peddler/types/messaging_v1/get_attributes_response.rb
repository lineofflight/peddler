# frozen_string_literal: true

require "peddler/types/messaging_v1/error"

module Peddler
  module Types
    module MessagingV1
      # The response schema for the GetAttributes operation.
      GetAttributesResponse = Structure.new do
        # @return [Hash] The list of attributes related to the buyer.
        attribute(:buyer, Hash)

        # @return [Array<Error>]
        attribute(:errors, [Error])
      end
    end
  end
end
