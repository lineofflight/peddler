# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/solicitations_v1/error"

module Peddler
  module Types
    module SolicitationsV1
      # The response schema for the getSolicitationActionsForOrder operation.
      GetSolicitationActionsForOrderResponse = Structure.new do
        # @return [Hash]
        attribute(:_links, Hash)

        # @return [Hash]
        attribute(:_embedded, Hash)

        # @return [Array<Error>]
        attribute(:errors, [Error])
      end
    end
  end
end
