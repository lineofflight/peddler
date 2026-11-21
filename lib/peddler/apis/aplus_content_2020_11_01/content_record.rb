# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AplusContent20201101
      # A content document with additional information for content management.
      ContentRecord = Structure.new do
        attribute(:content_reference_key, String, null: false, from: "contentReferenceKey")

        attribute?(:content_document, ContentDocument, from: "contentDocument")

        attribute?(:content_metadata, ContentMetadata, from: "contentMetadata")
      end
    end
  end
end
