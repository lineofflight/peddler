# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class SolicitationsV1
      # The response schema for the getSolicitationActionsForOrder operation.
      GetSolicitationActionsForOrderResponse = Structure.new do
        # @return [Hash]
        attribute?(:_embedded, Hash)

        # @return [Hash]
        attribute?(:_links, Hash)

        # @return [Array<Error>]
        attribute?(:errors, [Error])
      end
    end
  end
end
