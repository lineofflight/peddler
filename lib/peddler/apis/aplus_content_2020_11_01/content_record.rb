# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
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
