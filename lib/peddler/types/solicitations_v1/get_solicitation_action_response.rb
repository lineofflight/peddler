# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/solicitations_v1/error"
require "peddler/types/solicitations_v1/solicitations_action"

module Peddler
  module Types
    module SolicitationsV1
      # Describes a solicitation action that can be taken for an order. Provides a JSON Hypertext Application Language
      # (HAL) link to the JSON schema document that describes the expected input.
      GetSolicitationActionResponse = Structure.new do
        # @return [Hash]
        attribute?(:_embedded, Hash)

        # @return [Hash]
        attribute?(:_links, Hash)

        # @return [Array<Error>]
        attribute?(:errors, [Error])

        # @return [SolicitationsAction]
        attribute?(:payload, SolicitationsAction)
      end
    end
  end
end
