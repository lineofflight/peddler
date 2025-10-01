# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/solicitations_v1/error"

module Peddler
  module Types
    module SolicitationsV1
      GetSchemaResponse = Structure.new do
        # @return [Hash]
        attribute?(:_links, Hash)

        # @return [Array<Error>]
        attribute?(:errors, [Error])

        # @return [Hash]
        attribute?(:payload, Hash)
      end
    end
  end
end
