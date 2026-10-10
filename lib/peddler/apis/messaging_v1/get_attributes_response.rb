# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module MessagingV1
      # The response schema for the GetAttributes operation.
      GetAttributesResponse = Structure.new do
        # The list of attributes related to the buyer.
        attribute?(:buyer, Hash)

        attribute?(:errors, [Error])
      end
    end
  end
end
