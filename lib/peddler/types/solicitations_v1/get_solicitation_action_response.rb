# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/solicitations_v1/solicitations_action"
require "peddler/types/solicitations_v1/error"

module Peddler
  module Types
    module SolicitationsV1
      # Describes a solicitation action that can be taken for an order. Provides a JSON Hypertext Application Language
      # (HAL) link to the JSON schema document that describes the expected input.
      GetSolicitationActionResponse = Structure.new do
        # @return [Hash]
        attribute?(:_links, Hash)

        # @return [Hash]
        attribute?(:_embedded, Hash)

        # @return [SolicitationsAction]
        attribute?(:payload, SolicitationsAction)

        # @return [Array<Error>]
        attribute?(:errors, [Error])
      end
    end
  end
end
