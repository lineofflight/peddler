# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module ProductTypeDefinitions20200901
      SchemaLink = Structure.new do
        # @return [Hash] Link to retrieve the schema.
        attribute(:link, Hash)

        # @return [String] Checksum hash of the schema (Base64 MD5). Can be used to verify schema contents, identify
        # changes between schema versions, and for caching.
        attribute(:checksum, String)
      end
    end
  end
end
