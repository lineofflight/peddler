# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductTypeDefinitions20200901
      # A link to metadata schema.
      SchemaLink = Structure.new do
        # @return [String] Checksum hash of the schema (Base64 MD5). Use this to verify schema contents, identify
        #   changes between schema versions, and for caching.
        attribute(:checksum, String, null: false)

        # @return [Hash] Link to retrieve the schema.
        attribute(:link, Hash, null: false)
      end
    end
  end
end
