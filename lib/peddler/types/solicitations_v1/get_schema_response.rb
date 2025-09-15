# frozen_string_literal: true

require "peddler/types/solicitations_v1/schema"
require "peddler/types/solicitations_v1/error"

module Peddler
  module Types
    module SolicitationsV1
      GetSchemaResponse = Structure.new do
        # @return [Hash]
        attribute(:_links, Hash)

        # @return [Schema]
        attribute(:payload, Schema)

        # @return [Array<Error>]
        attribute(:errors, [Error])
      end
    end
  end
end
