# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/aplus_content_2020_11_01/content_document"
require "peddler/types/aplus_content_2020_11_01/content_metadata"

module Peddler
  module Types
    module AplusContent20201101
      # A content document with additional information for content management.
      ContentRecord = Structure.new do
        # @return [String]
        attribute(:content_reference_key, String, from: "contentReferenceKey")

        # @return [ContentDocument]
        attribute?(:content_document, ContentDocument, from: "contentDocument")

        # @return [ContentMetadata]
        attribute?(:content_metadata, ContentMetadata, from: "contentMetadata")
      end
    end
  end
end
