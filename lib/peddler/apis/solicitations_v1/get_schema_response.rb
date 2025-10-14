# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class SolicitationsV1
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
