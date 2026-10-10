# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module SolicitationsV1
      # The response schema for the getSolicitationActionsForOrder operation.
      GetSolicitationActionsForOrderResponse = Structure.new do
        attribute?(:_embedded, Hash)

        attribute?(:_links, Hash)

        attribute?(:errors, [Error])
      end
    end
  end
end
