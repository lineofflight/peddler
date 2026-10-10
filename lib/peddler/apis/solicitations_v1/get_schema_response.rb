# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module SolicitationsV1
      GetSchemaResponse = Structure.new do
        attribute?(:_links, Hash)

        attribute?(:errors, [Error])

        attribute?(:payload, Hash)
      end
    end
  end
end
