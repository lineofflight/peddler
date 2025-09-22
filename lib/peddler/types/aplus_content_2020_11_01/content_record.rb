# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/aplus_content_2020_11_01/content_metadata"
require "peddler/types/aplus_content_2020_11_01/content_document"

module Peddler
  module Types
    module AplusContent20201101
      # A content document with additional information for content management.
      ContentRecord = Structure.new do
        # @return [String]
        attribute(:content_reference_key, String, from: "contentReferenceKey")

        # @return [ContentMetadata]
        attribute(:content_metadata, ContentMetadata, from: "contentMetadata")

        # @return [ContentDocument]
        attribute(:content_document, ContentDocument, from: "contentDocument")
      end
    end
  end
end
