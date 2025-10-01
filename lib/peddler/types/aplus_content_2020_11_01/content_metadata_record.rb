# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/aplus_content_2020_11_01/content_metadata"

module Peddler
  module Types
    module AplusContent20201101
      # The metadata for an A+ Content document, with additional information for content management.
      ContentMetadataRecord = Structure.new do
        # @return [ContentMetadata]
        attribute(:content_metadata, ContentMetadata, from: "contentMetadata")

        # @return [String]
        attribute(:content_reference_key, String, from: "contentReferenceKey")
      end
    end
  end
end
