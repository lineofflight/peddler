# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module SolicitationsV1
      # Describes a solicitation action that can be taken for an order. Provides a JSON Hypertext Application Language
      # (HAL) link to the JSON schema document that describes the expected input.
      GetSolicitationActionResponse = Structure.new do
        attribute?(:_embedded, Hash)

        attribute?(:_links, Hash)

        attribute?(:errors, [Error])

        attribute?(:payload, SolicitationsAction)
      end
    end
  end
end
