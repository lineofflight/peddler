# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/solicitations_v1/error"
require "peddler/types/solicitations_v1/schema"

module Peddler
  module Types
    module SolicitationsV1
      GetSchemaResponse = Structure.new do
        # @return [Hash]
        attribute?(:_links, Hash)

        # @return [Array<Error>]
        attribute?(:errors, [Error])

        # @return [Schema]
        attribute?(:payload, Schema)
      end
    end
  end
end
