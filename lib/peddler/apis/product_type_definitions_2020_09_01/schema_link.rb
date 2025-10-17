# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductTypeDefinitions20200901
      SchemaLink = Structure.new do
        # @return [String] Checksum hash of the schema (Base64 MD5). Can be used to verify schema contents, identify
        #   changes between schema versions, and for caching.
        attribute(:checksum, String)

        # @return [Hash] Link to retrieve the schema.
        attribute(:link, Hash)
      end
    end
  end
end
